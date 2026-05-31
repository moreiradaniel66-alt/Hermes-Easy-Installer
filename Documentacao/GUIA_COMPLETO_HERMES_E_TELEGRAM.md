# Guia completo: instalar Hermes Agent e ligar no Telegram

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Este guia foi escrito para pessoas leigas. Siga na ordem, sem pular etapas.

Se quiser um guia menor, use:

```text
GUIA_WINDOWS.md
GUIA_MACOS.md
GUIA_LINUX.md
GUIA_TELEGRAM.md
```

## Antes de começar

Você vai precisar de:

- um computador com internet;
- uma conta em algum provedor de IA compatível com o Hermes, ou uma API key desse provedor;
- Telegram instalado no celular ou computador;
- 20 a 40 minutos livres na primeira instalação.

Importante: este pacote não tem credenciais dentro dele. Suas chaves ficam apenas na sua máquina e são configuradas pelo assistente oficial do Hermes.

## O que você vai fazer

1. Instalar o Hermes Agent.
2. Configurar o modelo de IA.
3. Testar o Hermes no terminal.
4. Criar um bot no Telegram pelo BotFather.
5. Descobrir seu Telegram User ID.
6. Conectar o bot ao Hermes.
7. Testar mensagem no Telegram.

## Parte 1 - Instalar o Hermes

### Windows

1. Extraia o arquivo `.zip`, se você recebeu este pacote compactado.
2. Abra a pasta `Hermes Easy Installer`.
3. Dê dois cliques em `INSTALAR_WINDOWS.bat`.
4. Se aparecer uma pergunta do Windows/PowerShell, permita a execução.
5. Aguarde o instalador terminar. Ele pode baixar Python, Node.js, Git e outras peças automaticamente.
6. Quando terminar, abra uma nova janela do PowerShell.
7. Digite:

```powershell
hermes
```

Se aparecer a conversa do Hermes, a instalação base funcionou.

Observação: o suporte nativo Windows do Hermes ainda é beta. Se algo estranho acontecer no Windows, o caminho mais testado é usar WSL2.

### macOS

1. Extraia o `.zip`.
2. Abra a pasta `Hermes Easy Installer`.
3. Tente dar dois cliques em `INSTALAR_MAC.command`.
4. Se o macOS bloquear, abra o Terminal nessa pasta e rode:

```bash
chmod +x ./INSTALAR_MAC.command
./INSTALAR_MAC.command
```

5. Quando terminar, feche e abra o Terminal.
6. Teste:

```bash
hermes
```

### Linux, WSL2 ou Termux

1. Abra o terminal dentro da pasta `Hermes Easy Installer`.
2. Rode:

```bash
chmod +x ./INSTALAR_LINUX.sh
./INSTALAR_LINUX.sh
```

3. Quando terminar, feche e abra o terminal, ou rode:

```bash
source ~/.bashrc
```

4. Teste:

```bash
hermes
```

## Parte 2 - Configurar o modelo de IA

Depois da instalação, o próprio pacote tenta abrir:

```bash
hermes model
```

Se não abrir, rode esse comando manualmente.

O que fazer nessa tela:

1. Escolha o provedor de IA que você usa.
2. Cole a API key ou faça login quando o assistente pedir.
3. Escolha um modelo.
4. Salve a configuração.
5. Teste com uma pergunta simples:

```bash
hermes
```

Mensagem de teste:

```text
Oi, Hermes. Responda apenas: instalação funcionando.
```

Se ele responder, continue para o Telegram.

Regra de ouro: não configure Telegram antes de uma conversa normal funcionar no terminal.

## Parte 3 - Criar o bot no Telegram

No Telegram, o bot oficial para criar bots se chama `@BotFather`.

1. Abra o Telegram.
2. Pesquise por `@BotFather`.
3. Entre no BotFather oficial.
4. Envie:

```text
/start
```

5. Envie:

```text
/newbot
```

6. O BotFather vai pedir o nome do bot.

Exemplo de nome:

```text
Meu Hermes Pessoal
```

7. Depois ele vai pedir o username do bot.

O username precisa:

- terminar com `bot`;
- ter entre 5 e 32 caracteres;
- usar letras latinas, números ou `_`;
- ser único no Telegram.

Exemplos:

```text
meu_hermes_bot
joao_agente_bot
assistente_carla_bot
```

8. Se o nome estiver disponível, o BotFather vai entregar um token.

O token parece com isso:

```text
123456789:ABCdefGHIjklMNOpqrSTUvwxYZ
```

Esse token é uma senha do bot. Não publique, não mande em grupo e não coloque em repositório público.

## Parte 4 - Descobrir seu ID numérico no Telegram

O Hermes usa um número de usuário para decidir quem pode falar com o bot.
Nesta etapa, você vai usar um bot auxiliar só para descobrir esse número. Ele não é o bot Hermes que você acabou de criar.

1. No Telegram, pesquise pelo bot auxiliar `@userinfobot`.
2. Envie:

```text
/start
```

3. Esse bot auxiliar vai responder com seu ID numérico.
4. Copie esse número.

Exemplo:

```text
123456789
```

Se `@userinfobot` não funcionar, tente `@get_id_bot`.

## Parte 5 - Conectar Telegram ao Hermes

Volte para o computador.

No Windows, abra o PowerShell.
No macOS ou Linux, abra o Terminal.

Cole este comando e pressione Enter:


```bash
hermes gateway setup
```

No assistente:

1. Escolha Telegram.
2. Cole o token recebido do BotFather.
3. Quando pedir usuários autorizados, cole seu Telegram User ID.
4. Salve a configuração.

Depois, no mesmo PowerShell/Terminal, cole este comando e pressione Enter:

```bash
hermes gateway start
```

Se esse comando não funcionar no seu sistema, tente:

```bash
hermes gateway
```

Ou, em Linux/WSL2/macOS:

```bash
hermes gateway run
```

## Parte 6 - Testar no Telegram

1. Abra o Telegram.
2. Pesquise pelo username do seu bot.
3. Abra a conversa com ele.
4. Toque em `Start` ou envie:

```text
/start
```

5. Envie:

```text
Oi, Hermes. Você está conectado?
```

Se tudo estiver certo, o Hermes responde pelo Telegram.

## Parte 7 - Definir canal principal

Se você quiser que tarefas agendadas do Hermes sejam entregues nesse chat, envie no próprio Telegram:

```text
/sethome
```

Isso define aquele chat como canal principal.

## Segurança básica

- Não compartilhe o token do BotFather.
- Autorize só o seu Telegram User ID.
- Não deixe o bot aberto para qualquer pessoa.
- Se o token vazar, volte ao BotFather e gere outro token com `/token`.
- Para grupos, comece sempre com teste em conversa privada.

## Comandos úteis

```bash
hermes
hermes model
hermes doctor
hermes gateway setup
hermes gateway status
hermes gateway start
hermes gateway run
hermes update
```

## Problemas comuns

### `hermes: command not found`

Abra um terminal novo.

No Linux/macOS/WSL2, tente:

```bash
source ~/.bashrc
```

Depois rode:

```bash
hermes doctor
```

### O bot não responde

Confira:

```bash
hermes gateway status
```

Tente iniciar:

```bash
hermes gateway start
```

Se estiver em WSL2 e o serviço não ficar ligado:

```bash
hermes gateway run
```

### Token inválido

Volte no `@BotFather`, confira o token e rode de novo:

```bash
hermes gateway setup
```

### Meu ID não é meu @username

Correto. O Hermes precisa do ID numérico, não do nome do seu bot e não do `@usuario`.

Use:

```text
@userinfobot
```

### Funciona no terminal, mas não no Telegram

Isso normalmente significa que o gateway não está rodando ou que seu usuário não foi autorizado.

Rode:

```bash
hermes gateway setup
hermes gateway status
```

## Referências oficiais

- Instalação Hermes: https://hermes-agent.nousresearch.com/docs/getting-started/installation/
- Quickstart Hermes: https://hermes-agent.nousresearch.com/docs/getting-started/quickstart/
- Telegram no Hermes: https://hermes-agent.nousresearch.com/docs/zh-Hans/user-guide/messaging/telegram
- BotFather: https://core.telegram.org/bots/features#botfather
