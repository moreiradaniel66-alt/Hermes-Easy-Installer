# Hermes Easy Installer

Instalador amigavel para o Hermes Agent da Nous Research, criado para reduzir atrito no primeiro setup e guiar usuarios em Windows, macOS, Linux, WSL2 e Termux.

O projeto nao guarda, envia nem inclui credenciais. Ele baixa o instalador oficial mais recente do Hermes Agent, conduz o usuario pelo fluxo de instalacao e aponta para os comandos oficiais de configuracao e diagnostico.

## Comece por aqui

Abra o assistente visual:

```text
COMECE_AQUI.html
```

Ou use o instalador direto do seu sistema:

```text
INSTALAR_WINDOWS.bat
INSTALAR_MAC.command
INSTALAR_LINUX.sh
```

## Estrutura

```text
Documentacao/   Guias completos, checklist e solucao de problemas
_motor/         Scripts internos do instalador e assets
```

## Seguranca

- Nao coloque tokens, API keys, cookies, `.env`, `config.yaml` ou logs neste repositorio.
- Credenciais ficam com o usuario e sao tratadas pelo fluxo oficial do Hermes.
- Se um token do Telegram vazar, gere outro no BotFather antes de continuar.

## Links oficiais

- Documentacao: https://hermes-agent.nousresearch.com/docs/
- Instalacao: https://hermes-agent.nousresearch.com/docs/getting-started/installation/
- GitHub oficial: https://github.com/NousResearch/hermes-agent
