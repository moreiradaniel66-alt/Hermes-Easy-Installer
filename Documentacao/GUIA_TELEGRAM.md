# Guia Telegram

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Siga este guia depois que o Hermes já estiver respondendo no terminal.

## 1. Criar o bot no BotFather

1. Abra o Telegram.
2. Pesquise por:

```text
@BotFather
```

3. Entre no BotFather oficial.
4. Envie:

```text
/start
```

5. Envie:

```text
/newbot
```

6. Escolha um nome para o bot.

Exemplo:

```text
Meu Hermes Pessoal
```

7. Escolha um username terminado em `bot`.

Exemplos:

```text
meu_hermes_bot
assistente_maria_bot
agente_joao_bot
```

8. Copie o token que o BotFather entregar.

O token parece com isso:

```text
123456789:ABCdefGHIjklMNOpqrSTUvwxYZ
```

Esse token é uma senha. Não publique e não envie para outras pessoas.

## 2. Descobrir seu ID numérico no Telegram

Agora você vai usar um bot auxiliar só para descobrir seu número de usuário. Ele não é o bot Hermes que você acabou de criar.

1. Pesquise por:

```text
@userinfobot
```

2. Envie:

```text
/start
```

3. Copie o número do seu usuário.

Se esse bot não funcionar, tente:

```text
@get_id_bot
```

Importante: o Hermes precisa do número, não do nome do seu bot e não do seu `@username`.

## 3. Conectar no Hermes

Agora volte para o computador.

No Windows, abra o PowerShell.
No macOS ou Linux, abra o Terminal.

Cole este comando e pressione Enter:

```bash
hermes gateway setup
```

No assistente:

1. escolha Telegram;
2. cole o token do BotFather;
3. cole seu Telegram User ID numérico;
4. salve.

## 4. Iniciar o gateway

No mesmo PowerShell/Terminal, cole este comando e pressione Enter:

```bash
hermes gateway start
```

Se não funcionar:

```bash
hermes gateway
```

No Linux, macOS ou WSL2, também pode usar:

```bash
hermes gateway run
```

## 5. Testar

1. Abra seu bot no Telegram.
2. Envie:

```text
/start
```

3. Depois envie:

```text
Oi, Hermes. Você está conectado?
```

Se ele responder, deu certo.

## 6. Canal principal

Para definir esse chat como canal principal do Hermes, envie no Telegram:

```text
/sethome
```

## Segurança

- Não compartilhe o token.
- Autorize apenas o seu ID.
- Se o token vazar, gere outro no `@BotFather`.
- Comece em conversa privada antes de colocar o bot em grupo.
