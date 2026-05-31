# Guia Windows

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Siga este guia se você usa Windows.

## 1. Abrir a pasta

1. Extraia o arquivo `Hermes Easy Installer.zip`.
2. Abra a pasta `Hermes Easy Installer`.
3. Não mexa na pasta `_motor`.
4. A pasta `Documentacao` é só para leitura.

## 2. Instalar

1. Dê dois cliques em:

```text
INSTALAR_WINDOWS.bat
```

2. Ele vai abrir o assistente Windows nativo.
3. Clique em `Instalar Hermes no Windows`.
4. Se o Windows perguntar se pode executar, confirme.
5. Aguarde. A primeira instalação pode demorar porque o Hermes baixa dependências.
6. Quando terminar, abra uma nova janela do PowerShell.

## 3. Testar o Hermes

No PowerShell, rode:

```powershell
hermes
```

Se ele abrir uma conversa, envie:

```text
Oi, Hermes. Responda apenas: instalação funcionando.
```

## 4. Configurar modelo/API key

Se o assistente não abrir sozinho:

1. Abra o PowerShell.
2. Cole este comando.
3. Pressione Enter.

```powershell
hermes model
```

Quando o assistente abrir, escolha o provedor/modelo, cole a API key quando for pedido e salve.

Depois teste:

```powershell
hermes
```

Só siga para o Telegram depois que o Hermes responder no PowerShell.

## 5. Configurar Telegram

Depois que o Hermes responder no PowerShell, siga o guia:

```text
GUIA_TELEGRAM.md
```

## Observação importante

O Hermes nativo no Windows ainda é beta. Se algo falhar muitas vezes, o caminho mais estável é instalar pelo WSL2.
