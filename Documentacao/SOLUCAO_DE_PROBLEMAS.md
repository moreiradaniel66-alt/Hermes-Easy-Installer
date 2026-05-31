# Solução de problemas

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

## O instalador fecha rápido no Windows

Abra a pasta, clique com o botão direito em `INSTALAR_WINDOWS.bat` e escolha abrir.

Se ainda fechar, abra o PowerShell dentro da pasta e rode:

```powershell
.\INSTALAR_WINDOWS.bat
```

## `hermes` não é reconhecido

Abra uma nova janela de terminal.

No Linux/macOS/WSL2:

```bash
source ~/.bashrc
```

Depois:

```bash
hermes doctor
```

## O Hermes instalou, mas não conversa

Rode:

```bash
hermes model
```

Configure o provedor/modelo e teste:

```bash
hermes
```

## O Telegram não responde

Rode:

```bash
hermes gateway status
```

Depois tente:

```bash
hermes gateway start
```

Se estiver usando WSL2/Linux/macOS e o serviço não iniciar:

```bash
hermes gateway run
```

Deixe esse terminal aberto enquanto usa o bot.

## Errei o token do Telegram

Rode novamente:

```bash
hermes gateway setup
```

Cole o token correto do `@BotFather`.

## O Hermes diz que meu usuário não está autorizado

Você provavelmente colocou o `@username` em vez do ID numérico.

Use o bot auxiliar `@userinfobot` para descobrir seu ID numérico e rode:

```bash
hermes gateway setup
```

## Quero trocar de modelo

```bash
hermes model
```

## Quero atualizar o Hermes

```bash
hermes update
```

## Meu token vazou

1. Abra `@BotFather`.
2. Use `/token`.
3. Gere um novo token.
4. Rode `hermes gateway setup` novamente.
5. Nunca publique o token antigo.
