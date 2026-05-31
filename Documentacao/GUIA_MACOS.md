# Guia macOS

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Siga este guia se você usa MacBook, iMac ou Mac mini.

## 1. Abrir a pasta

1. Extraia o arquivo `Hermes Easy Installer.zip`.
2. Abra a pasta `Hermes Easy Installer`.
3. Não mexa na pasta `_motor`.

## 2. Instalar

Tente dar dois cliques em:

```text
INSTALAR_MAC.command
```

Se o macOS bloquear por permissão:

1. Abra o app Terminal.
2. Arraste a pasta `Hermes Easy Installer` para dentro do Terminal ou navegue até ela.
3. Rode:

```bash
chmod +x ./INSTALAR_MAC.command
./INSTALAR_MAC.command
```

## 3. Testar o Hermes

Feche e abra o Terminal.

Rode:

```bash
hermes
```

Envie:

```text
Oi, Hermes. Responda apenas: instalação funcionando.
```

## 4. Configurar modelo/API key

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

## 5. Configurar Telegram

Depois que o Hermes responder no Terminal, siga:

```text
GUIA_TELEGRAM.md
```
