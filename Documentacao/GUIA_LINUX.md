# Guia Linux, WSL2 ou Termux

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Siga este guia se você usa Linux, WSL2 no Windows ou Termux no Android.

## 1. Abrir a pasta

1. Extraia o arquivo `Hermes Easy Installer.zip`.
2. Abra o terminal dentro da pasta `Hermes Easy Installer`.
3. Não mexa na pasta `_motor`.

## 2. Instalar

Rode:

```bash
chmod +x ./INSTALAR_LINUX.sh
./INSTALAR_LINUX.sh
```

Alternativa sem dar permissão:

```bash
bash ./INSTALAR_LINUX.sh
```

## 3. Recarregar terminal

Depois da instalação, feche e abra o terminal.

Se preferir, rode:

```bash
source ~/.bashrc
```

## 4. Testar o Hermes

```bash
hermes
```

Envie:

```text
Oi, Hermes. Responda apenas: instalação funcionando.
```

## 5. Configurar modelo/API key

Se o assistente não abrir sozinho:

1. Abra o Terminal.
2. Cole este comando.
3. Pressione Enter.

```bash
hermes model
```

Quando o assistente abrir, escolha o provedor/modelo, cole a API key quando for pedido e salve.

Depois teste:

```bash
hermes
```

Só siga para o Telegram depois que o Hermes responder no Terminal.

## 6. Configurar Telegram

Depois que o Hermes responder no terminal, siga:

```text
GUIA_TELEGRAM.md
```

## WSL2

Se o Telegram não ficar ativo em segundo plano no WSL2, use:

```bash
hermes gateway run
```

Deixe esse terminal aberto enquanto usa o bot.
