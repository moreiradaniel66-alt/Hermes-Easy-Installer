# Hermes Easy Installer (Versão 2026)

**Hermes Agent**: Assistente autônomo de inteligência artificial da **Nous Research** com criação dinâmica de ferramentas, memória contínua e gateways multicanais.  
**Hermes Easy Installer**: Ferramenta de automação e interface portátil desenvolvida por **Daniel Moreira** · **Moreira Labs** ([@moreiralabs](https://instagram.com/moreiralabs)).

---

## 🚀 Como Executar

### 🪟 Windows (10 ou 11) - Modo Portátil Recomendado
Basta dar **duplo clique** em:
```text
Hermes Easy Installer.exe
```
> O aplicativo portátil abre instantaneamente em uma janela desktop estilizada e moderna, permitindo instalar com **1 clique**, gerenciar provedores, abrir o Web Dashboard e configurar o Telegram sem depender do terminal.

**Alternativa via Terminal / Batch:**
```text
INSTALAR_WINDOWS.bat
```
Oferece um menu interativo rápido no prompt de comando:
- `[1]` Instalação padrão do Hermes Agent CLI (assistente autônomo + gateways)
- `[2]` Instalação completa com **Hermes Desktop** (app gráfico oficial da Nous Research)
- `[3]` Iniciar o **Hermes Web Dashboard** (`http://127.0.0.1:9119`)
- `[4]` Abrir o Painel Portátil (`Hermes Easy Installer.exe`)
- `[5]` Abrir Guia Visual no Navegador (`COMECE_AQUI.html`)
- `[6]` Configurar Provedor e Chaves (`hermes setup`)
- `[7]` Diagnóstico do Ambiente (`hermes doctor`)
- `[8]` Configurar Gateway Telegram (`hermes gateway setup`)

---

### 🍎 macOS
Dê **duplo clique** em `INSTALAR_MAC.command` ou execute no Terminal:
```bash
chmod +x ./INSTALAR_MAC.command
./INSTALAR_MAC.command
```

### 🐧 Linux, WSL2 e Termux (Android)
Execute no terminal:
```bash
chmod +x ./INSTALAR_LINUX.sh
./INSTALAR_LINUX.sh
```

---

## 🌐 Instalação Direta via Linha de Comando (Universal)

Caso prefira rodar diretamente via terminal em qualquer máquina sem baixar o pacote:

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://hermes-agent.nousresearch.com/install.ps1 | iex"
```

**Linux / macOS:**
```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

---

## 📊 Hermes Web Dashboard

O Hermes Agent inclui um painel de controle visual oficial acessível pelo navegador:

```bash
hermes dashboard
```
- **Endereço:** `http://127.0.0.1:9119`
- **Recursos:** Gerenciamento de conversas, editor de memórias e personas (`SOUL.md`), monitor de ferramentas autônomas MCP e gráficos de consumo.

---

## 🛠️ Comandos Essenciais do Hermes

Após a instalação (em um terminal recém-aberto):

| Comando | Descrição |
| :--- | :--- |
| `hermes` | Inicia o assistente no terminal |
| `hermes dashboard` | Abre o painel de controle web em `http://127.0.0.1:9119` |
| `hermes setup` | Assistente interativo de configuração de chaves e provedores |
| `hermes model` | Troca rápida de modelos (OpenRouter, Anthropic, OpenAI, etc.) |
| `hermes doctor` | Diagnóstico automático de dependências, ambiente e chaves |
| `hermes gateway setup` | Assistente de conexão com bots (Telegram, Discord, Slack) |
| `hermes gateway start` | Inicia o gateway em segundo plano (24/7) |
| `hermes gateway status`| Verifica o status de conexão do gateway |

---

## 🔒 Segurança & Privacidade

- Este instalador **não armazena nem transmite** dados pessoais ou chaves de API.
- Todo o processamento e armazenamento de credenciais ocorre localmente no diretório seguro do usuário: `~/.hermes/` (ou `%LOCALAPPDATA%\hermes\` no Windows).
