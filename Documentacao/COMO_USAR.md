# Como usar

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Este pacote instala o Hermes Agent usando os instaladores oficiais da Nous Research.

Se você é iniciante, comece abrindo este guia:

```text
COMECE_AQUI.html
```

Ele fica na pasta principal, junto dos instaladores.

## Windows

Clique duas vezes em:

```text
INSTALAR_WINDOWS.bat
```

Ele abre um assistente Windows nativo com botão real de instalação.

Guia detalhado:

```text
GUIA_WINDOWS.md
```

Se o Windows perguntar, confirme que deseja executar.

## macOS

Clique duas vezes em:

```text
INSTALAR_MAC.command
```

Guia detalhado:

```text
GUIA_MACOS.md
```

Se o macOS bloquear por permissão, abra o Terminal dentro desta pasta e rode:

```bash
chmod +x ./INSTALAR_MAC.command
./INSTALAR_MAC.command
```

Guia detalhado:

```text
GUIA_LINUX.md
```

## Linux, WSL2 ou Termux

No terminal, dentro desta pasta:

```bash
chmod +x ./INSTALAR_LINUX.sh
./INSTALAR_LINUX.sh
```

## Login, conta e API key

Depois de instalar, o pacote abre o assistente oficial:

```bash
hermes model
```

É ali que cada pessoa escolhe provedor, login ou API key. Este projeto não salva credenciais.

Se precisar fazer manualmente:

1. Abra o PowerShell no Windows, ou Terminal no macOS/Linux.
2. Cole `hermes model`.
3. Pressione Enter.
4. Escolha o provedor/modelo e cole a API key quando o Hermes pedir.
5. Teste com `hermes` antes de seguir para o Telegram.

## Telegram

Depois que o Hermes responder no terminal, siga:

```text
GUIA_TELEGRAM.md
```

Resumo:

1. Crie um bot no Telegram com `@BotFather`.
2. Copie o token.
3. Descubra seu ID numérico com o bot auxiliar `@userinfobot`.
4. Abra o PowerShell/Terminal, cole `hermes gateway setup` e pressione Enter.
5. Escolha Telegram, cole token e ID.
6. Inicie o gateway e teste no Telegram.

## Diagnóstico

Para conferir se deu tudo certo:

```bash
hermes doctor
```

## Abrir documentação no Bloco de Notas

No Windows, dentro da pasta `Documentacao`, existe:

```text
ABRIR_DOCUMENTACAO_NO_BLOCO_DE_NOTAS.bat
```

Dê dois cliques nele para escolher qual guia abrir no Bloco de Notas.
