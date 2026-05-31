# Security

Desenvolvido por Daniel Moreira · Instagram `@moreiraprodux`

Este projeto é apenas um wrapper para os instaladores oficiais do Hermes Agent.

## Regras do projeto

- Não commitar API keys, tokens, cookies, arquivos `.env`, `config.yaml` ou logs.
- Não adicionar credenciais pessoais nos scripts.
- Não coletar chaves diretamente neste wrapper.
- Sempre delegar login/modelo/API key ao assistente oficial do Hermes (`hermes model` ou `hermes setup`).
- Antes de compartilhar um zip ou repositório, confira se não existe pasta de dados local do Hermes dentro do projeto.

## Arquivos que não devem ser publicados

```text
.env
*.env
config.yaml
config.yml
*.log
logs/
sessions/
data/
```

## Reportar problema

Se encontrar algum vazamento acidental de credencial, apague a credencial do histórico público, revogue a chave afetada no provedor e gere uma nova.
