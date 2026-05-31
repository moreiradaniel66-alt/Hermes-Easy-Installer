# Hermes Easy Installer

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Instalador amigável para o [Hermes Agent](https://hermes-agent.nousresearch.com/) da Nous Research.

Este projeto não guarda, envia nem inclui credenciais. Ele só facilita o caminho:

1. baixa o instalador oficial mais recente do Hermes Agent;
2. instala dependências usando o fluxo oficial;
3. abre o assistente oficial de login/modelo (`hermes model` ou `hermes setup`);
4. roda `hermes doctor` para conferir se ficou tudo certo.

## Arquivos principais

```text
COMECE_AQUI.html      -> assistente visual na raiz da pasta
INSTALAR_WINDOWS.bat  -> Windows, duplo clique
INSTALAR_MAC.command  -> macOS, duplo clique quando permitido
INSTALAR_LINUX.sh     -> Linux, WSL2 e Termux
instalar.ps1          -> instalação direta via comando público
Documentacao/        -> guias passo a passo
_motor/              -> scripts internos, não precisa mexer
```

No Windows, `INSTALAR_WINDOWS.bat` abre um assistente nativo via HTA. Esse modo consegue executar o instalador real, diferente do navegador comum, que só consegue abrir arquivos como texto.

Dentro de `Documentacao/`, os guias principais são:

```text
COMECE_AQUI.html     -> guia visual para iniciantes
GUIA_WINDOWS.md      -> passo a passo para Windows
GUIA_MACOS.md        -> passo a passo para MacBook/macOS
GUIA_LINUX.md        -> passo a passo para Linux, WSL2 e Termux
GUIA_TELEGRAM.md     -> criar bot no Telegram e conectar ao Hermes
CHECKLIST_INSTALACAO.md
SOLUCAO_DE_PROBLEMAS.md
ABRIR_DOCUMENTACAO_NO_BLOCO_DE_NOTAS.bat -> menu Windows para abrir guias no Bloco de Notas
```

## Instalação no Windows

Comando direto para PowerShell ou CMD:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/moreiradaniel66-alt/Hermes-Easy-Installer/main/instalar.ps1 | iex"
```

Modo mais fácil: dê dois cliques em:

```text
INSTALAR_WINDOWS.bat
```

Ou abra o PowerShell e rode:

```powershell
.\INSTALAR_WINDOWS.bat
```

O instalador nativo do Hermes para Windows ainda é beta. Para máxima compatibilidade, o próprio Hermes recomenda WSL2 como caminho mais testado, mas o instalador oficial PowerShell já cobre o fluxo comum.

## Instalação no macOS

Clique duas vezes em:

```text
INSTALAR_MAC.command
```

Se o macOS bloquear por permissão:

```bash
chmod +x ./INSTALAR_MAC.command
./INSTALAR_MAC.command
```

## Instalação no Linux, macOS, WSL2 ou Termux

No terminal:

```bash
chmod +x ./INSTALAR_LINUX.sh
./INSTALAR_LINUX.sh
```

Ou direto pela internet:

```bash
curl -fsSL https://raw.githubusercontent.com/moreiradaniel66-alt/Hermes-Easy-Installer/main/_motor/install-hermes-easy.sh | bash
```

## O que ele baixa

Windows:

```text
https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1
```

Linux/macOS/WSL2/Termux:

```text
https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh
```

Esses links apontam para o branch `main` oficial do Hermes Agent, então puxam a versão mais recente do instalador oficial no momento da execução.

## Segurança

- Não coloque API keys dentro deste repositório.
- Não publique arquivos `.env`, `config.yaml`, logs ou pastas de dados do Hermes.
- As credenciais são pedidas pelo assistente oficial do Hermes e ficam na máquina do usuário.
- Este wrapper não imprime nem registra chaves digitadas.

## Depois de instalar

Comandos úteis:

```bash
hermes
hermes model
hermes setup
hermes gateway setup
hermes gateway status
hermes doctor
hermes update
```

## Fontes oficiais

- Documentação: https://hermes-agent.nousresearch.com/docs/
- Instalação: https://hermes-agent.nousresearch.com/docs/getting-started/installation/
- GitHub: https://github.com/NousResearch/hermes-agent
