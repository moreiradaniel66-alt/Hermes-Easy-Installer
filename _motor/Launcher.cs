using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Diagnostics;

namespace HermesEasyInstaller
{
    static class Program
    {
        private static volatile bool _running = true;
        private static string _baseDir;
        private static int _port;
        private static DateTime _lastHeartbeat = DateTime.UtcNow;
        private static volatile bool _receivedHeartbeat = false;

        [STAThread]
        static void Main(string[] args)
        {
            _baseDir = AppDomain.CurrentDomain.BaseDirectory.TrimEnd('\\', '/');

            // Garantir instancia unica
            bool isNewInstance;
            using (Mutex mutex = new Mutex(true, "HermesEasyInstaller_SingleInstance_Mutex_2026", out isNewInstance))
            {
                if (!isNewInstance)
                {
                    // Ja existe uma instancia do Launcher em execucao
                    // Tenta abrir a pagina no navegador e sai
                    string htmlPath = Path.Combine(_baseDir, "COMECE_AQUI.html");
                    if (File.Exists(htmlPath)) Process.Start(htmlPath);
                    return;
                }

                _port = GetPort();

                HttpListener listener = new HttpListener();
                listener.Prefixes.Add("http://127.0.0.1:" + _port + "/");

                try
                {
                    listener.Start();
                }
                catch
                {
                    string htmlPath = Path.Combine(_baseDir, "COMECE_AQUI.html");
                    if (File.Exists(htmlPath)) Process.Start(htmlPath);
                    return;
                }

                // Inicia a thread de atendimento HTTP
                Thread serverThread = new Thread(() =>
                {
                    while (_running)
                    {
                        try
                        {
                            HttpListenerContext context = listener.GetContext();
                            ThreadPool.QueueUserWorkItem((state) => HandleRequest((HttpListenerContext)state), context);
                        }
                        catch
                        {
                            if (!_running) break;
                        }
                    }
                });
                serverThread.IsBackground = true;
                serverThread.Start();

                string appUrl = "http://127.0.0.1:" + _port + "/";

                // Tenta abrir em App Mode nativo via Edge
                string edgePath = FindEdge();
                bool edgeStarted = false;

                if (!string.IsNullOrEmpty(edgePath) && File.Exists(edgePath))
                {
                    string edgeArgs = string.Format("--app=\"{0}\" --window-size=1260,900", appUrl);
                    ProcessStartInfo psi = new ProcessStartInfo(edgePath, edgeArgs);
                    psi.UseShellExecute = false;

                    try
                    {
                        Process proc = Process.Start(psi);
                        edgeStarted = (proc != null);
                    }
                    catch
                    {
                        edgeStarted = false;
                    }
                }

                if (!edgeStarted)
                {
                    try
                    {
                        Process.Start(appUrl);
                    }
                    catch
                    {
                        string htmlPath = Path.Combine(_baseDir, "COMECE_AQUI.html");
                        if (File.Exists(htmlPath)) Process.Start(htmlPath);
                    }
                }

                // Monitoramento de ciclo de vida:
                // O navegador envia heartbeats a cada 2.5s.
                // Enquanto a janela estiver aberta, o processo PERMANECE ATIVO.
                // Quando o usuario fecha a janela, os heartbeats cessam e encerramos.
                DateTime startTime = DateTime.UtcNow;
                while (_running)
                {
                    Thread.Sleep(1000);

                    // Antes do primeiro heartbeat: aguarda ate 90s para o Edge abrir e a pagina carregar
                    if (!_receivedHeartbeat)
                    {
                        if ((DateTime.UtcNow - startTime).TotalSeconds > 90)
                        {
                            _running = false;
                            break;
                        }
                        continue;
                    }

                    // Se ja conectou antes, mas ficou mais de 10s sem heartbeat (janela fechada)
                    if ((DateTime.UtcNow - _lastHeartbeat).TotalSeconds > 10)
                    {
                        _running = false;
                        break;
                    }

                    // Limite maximo total de seguranca: 8 horas
                    if ((DateTime.UtcNow - startTime).TotalHours > 8)
                    {
                        _running = false;
                        break;
                    }
                }

                try { listener.Stop(); } catch { }
            }
        }

        private static void HandleRequest(HttpListenerContext context)
        {
            HttpListenerRequest req = context.Request;
            HttpListenerResponse res = context.Response;

            // Headers CORS para suportar chamadas de qualquer origem local
            res.AddHeader("Access-Control-Allow-Origin", "*");
            res.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
            res.AddHeader("Access-Control-Allow-Headers", "*");

            if (req.HttpMethod == "OPTIONS")
            {
                res.StatusCode = 200;
                res.Close();
                return;
            }

            string path = req.Url.AbsolutePath;

            try
            {
                // Heartbeat do app
                if (path == "/api/heartbeat")
                {
                    _lastHeartbeat = DateTime.UtcNow;
                    _receivedHeartbeat = true;
                    SendString(res, "{\"ok\":true}", "application/json");
                    return;
                }

                // Status do servico
                if (path == "/api/status")
                {
                    _lastHeartbeat = DateTime.UtcNow;
                    _receivedHeartbeat = true;
                    string json = string.Format("{{\"status\":\"ok\",\"os\":\"windows\",\"port\":{0},\"appMode\":true}}", _port);
                    SendString(res, json, "application/json");
                    return;
                }

                // Disparo de acoes automatizadas (1-Clique)
                if (path == "/api/run")
                {
                    _lastHeartbeat = DateTime.UtcNow;
                    _receivedHeartbeat = true;
                    string action = req.QueryString["action"] ?? "";
                    string errorMsg;
                    bool ok = ExecuteAction(action, out errorMsg);

                    string json;
                    if (ok)
                    {
                        json = string.Format("{{\"success\":true,\"action\":\"{0}\"}}", action);
                    }
                    else
                    {
                        json = string.Format("{{\"success\":false,\"action\":\"{0}\",\"error\":\"{1}\"}}", action, (errorMsg ?? "Falha ao executar acao").Replace("\"", "\\\""));
                    }
                    SendString(res, json, "application/json");
                    return;
                }

                // Encerramento ordenado
                if (path == "/api/exit")
                {
                    SendString(res, "{\"success\":true,\"message\":\"closing\"}", "application/json");
                    _running = false;
                    return;
                }

                // Rota raiz e pagina inicial
                if (path == "/" || path == "/index.html" || path == "/COMECE_AQUI.html")
                {
                    string file = Path.Combine(_baseDir, "COMECE_AQUI.html");
                    ServeFile(res, file);
                    return;
                }

                // Arquivos estaticos locais seguros
                string relPath = path.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
                string fullPath = Path.GetFullPath(Path.Combine(_baseDir, relPath));

                if (fullPath.StartsWith(_baseDir, StringComparison.OrdinalIgnoreCase) && File.Exists(fullPath))
                {
                    ServeFile(res, fullPath);
                    return;
                }

                res.StatusCode = 404;
                SendString(res, "404 - Not Found", "text/plain");
            }
            catch (Exception ex)
            {
                try
                {
                    res.StatusCode = 500;
                    SendString(res, "500 - Error: " + ex.Message, "text/plain");
                }
                catch { }
            }
        }

        private static bool ExecuteAction(string action, out string errorMsg)
        {
            errorMsg = null;
            try
            {
                string scriptPath = Path.Combine(_baseDir, @"_motor\install-hermes-easy.ps1");
                string psArgs = null;
                string utf8 = "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::InputEncoding = [System.Text.Encoding]::UTF8; ";

                switch (action)
                {
                    case "install":
                        psArgs = string.Format("-NoExit -ExecutionPolicy Bypass -Command \"{0}& '{1}'\"", utf8, scriptPath);
                        break;
                    case "install-desktop":
                        psArgs = string.Format("-NoExit -ExecutionPolicy Bypass -Command \"{0}& '{1}' -IncludeDesktop\"", utf8, scriptPath);
                        break;
                    case "dashboard":
                        psArgs = string.Format("-NoExit -ExecutionPolicy Bypass -Command \"{0}& '{1}' -StartDashboard\"", utf8, scriptPath);
                        break;
                    case "setup":
                        psArgs = string.Format("-NoExit -ExecutionPolicy Bypass -Command \"{0}& '{1}' -SkipInstall\"", utf8, scriptPath);
                        break;
                    case "doctor":
                        psArgs = string.Format("-NoExit -ExecutionPolicy Bypass -Command \"{0}& '{1}' -SkipInstall -SkipModelSetup\"", utf8, scriptPath);
                        break;
                    case "gateway":
                        psArgs = string.Format("-NoExit -ExecutionPolicy Bypass -Command \"{0}& '{1}' -SkipInstall -SkipModelSetup -SkipDoctor\"", utf8, scriptPath);
                        break;
                    case "open-folder":
                        Process.Start("explorer.exe", "\"" + _baseDir + "\"");
                        return true;
                    default:
                        errorMsg = "Acao desconhecida: " + action;
                        return false;
                }

                if (!string.IsNullOrEmpty(psArgs))
                {
                    ProcessStartInfo psi = new ProcessStartInfo();
                    psi.FileName = "powershell.exe";
                    psi.Arguments = psArgs;
                    psi.WorkingDirectory = _baseDir;
                    psi.UseShellExecute = true;
                    Process.Start(psi);
                    return true;
                }
                errorMsg = "Nenhum comando gerado para a acao.";
                return false;
            }
            catch (Exception ex)
            {
                errorMsg = ex.Message;
                return false;
            }
        }

        private static void ServeFile(HttpListenerResponse res, string filePath)
        {
            if (!File.Exists(filePath))
            {
                res.StatusCode = 404;
                SendString(res, "File not found", "text/plain");
                return;
            }

            string ext = Path.GetExtension(filePath).ToLowerInvariant();
            string mime = "application/octet-stream";
            if (ext == ".html" || ext == ".htm") mime = "text/html; charset=utf-8";
            else if (ext == ".css") mime = "text/css; charset=utf-8";
            else if (ext == ".js") mime = "application/javascript; charset=utf-8";
            else if (ext == ".jpg" || ext == ".jpeg") mime = "image/jpeg";
            else if (ext == ".png") mime = "image/png";
            else if (ext == ".ico") mime = "image/x-icon";
            else if (ext == ".svg") mime = "image/svg+xml";
            else if (ext == ".json") mime = "application/json; charset=utf-8";

            byte[] bytes = File.ReadAllBytes(filePath);
            res.ContentType = mime;
            res.ContentLength64 = bytes.Length;
            res.OutputStream.Write(bytes, 0, bytes.Length);
            res.OutputStream.Close();
        }

        private static void SendString(HttpListenerResponse res, string content, string contentType)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(content);
            res.ContentType = contentType;
            res.ContentLength64 = bytes.Length;
            res.OutputStream.Write(bytes, 0, bytes.Length);
            res.OutputStream.Close();
        }

        private static int GetPort()
        {
            int[] preferredPorts = new int[] { 19284, 19285, 19286, 19287, 19288 };
            foreach (int p in preferredPorts)
            {
                try
                {
                    TcpListener l = new TcpListener(IPAddress.Loopback, p);
                    l.Start();
                    l.Stop();
                    return p;
                }
                catch { }
            }

            TcpListener any = new TcpListener(IPAddress.Loopback, 0);
            any.Start();
            int freePort = ((IPEndPoint)any.LocalEndpoint).Port;
            any.Stop();
            return freePort;
        }

        private static string FindEdge()
        {
            string[] paths = new string[]
            {
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), @"Microsoft\Edge\Application\msedge.exe"),
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), @"Microsoft\Edge\Application\msedge.exe"),
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Microsoft\Edge\Application\msedge.exe")
            };

            foreach (string p in paths)
            {
                if (File.Exists(p)) return p;
            }
            return null;
        }
    }
}
