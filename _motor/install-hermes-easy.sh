#!/usr/bin/env bash
set -euo pipefail

OFFICIAL_INSTALLER="https://hermes-agent.nousresearch.com/install.sh"
FALLBACK_INSTALLER="https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$(basename "$SCRIPT_DIR")" = "_motor" ]; then
  PACKAGE_ROOT="$(dirname "$SCRIPT_DIR")"
else
  PACKAGE_ROOT="$SCRIPT_DIR"
fi
DOCS_DIR="$PACKAGE_ROOT/Documentacao"

SKIP_INSTALL=0
SKIP_SETUP=0
SKIP_GATEWAY_SETUP=0
SKIP_DOCTOR=0
START_DASHBOARD=0
INCLUDE_DESKTOP=0
NON_INTERACTIVE=0

for arg in "$@"; do
  case "$arg" in
    --skip-install) SKIP_INSTALL=1 ;;
    --skip-setup|--skip-model-setup) SKIP_SETUP=1 ;;
    --skip-gateway-setup) SKIP_GATEWAY_SETUP=1 ;;
    --skip-doctor) SKIP_DOCTOR=1 ;;
    --dashboard) START_DASHBOARD=1 ;;
    --include-desktop) INCLUDE_DESKTOP=1 ;;
    --non-interactive) NON_INTERACTIVE=1 ;;
    -h|--help)
      cat <<'HELP'
Hermes Agent • Nous Research (2026) | Easy Installer por Moreira Labs

Opções:
  --skip-install       Não executa o instalador oficial.
  --skip-setup         Pula a execução de "hermes setup" após a instalação.
  --skip-gateway-setup Pula a configuração de gateways (Telegram, etc.).
  --skip-doctor        Pula o diagnóstico "hermes doctor".
  --dashboard          Inicia diretamente o Hermes Web Dashboard (porta 9119).
  --include-desktop    Compila e inclui o novo aplicativo Hermes Desktop.
  --non-interactive    Executa sem perguntas interativas no terminal.
  -h, --help           Exibe esta ajuda.
HELP
      exit 0
      ;;
    *)
      echo "[!] Opção desconhecida: $arg" >&2
      exit 2
      ;;
  esac
done

step() {
  printf '\n\033[0;36m==> %s\033[0m\n' "$1"
}

ok() {
  printf '\033[0;32m[OK] %s\033[0m\n' "$1"
}

warn() {
  printf '\033[0;33m[!] %s\033[0m\n' "$1"
}

confirm() {
  if [ "$NON_INTERACTIVE" -eq 1 ]; then
    return 0
  fi

  printf '%s [S/n] ' "$1"
  read -r answer
  case "$answer" in
    ""|s|S|y|Y) return 0 ;;
    *) return 1 ;;
  esac
}

need_downloader() {
  if command -v curl >/dev/null 2>&1; then
    echo "curl"
    return 0
  fi

  if command -v wget >/dev/null 2>&1; then
    echo "wget"
    return 0
  fi

  echo "Hermes Easy Installer precisa de curl ou wget instalado." >&2
  exit 1
}

run_official_installer() {
  local downloader
  downloader="$(need_downloader)"

  step "Baixando e executando o instalador oficial mais recente do Hermes Agent"

  local extra_flags=""
  if [ "$INCLUDE_DESKTOP" -eq 1 ]; then
    extra_flags="--include-desktop"
  fi

  if [ "$downloader" = "curl" ]; then
    if curl -fsSL "$OFFICIAL_INSTALLER" | bash -s -- $extra_flags; then
      ok "Instalador oficial concluído com sucesso."
      return 0
    else
      warn "Tentando repositório GitHub de backup..."
      curl -fsSL "$FALLBACK_INSTALLER" | bash -s -- $extra_flags
    fi
  else
    if wget -qO- "$OFFICIAL_INSTALLER" | bash -s -- $extra_flags; then
      ok "Instalador oficial concluído com sucesso."
      return 0
    else
      warn "Tentando repositório GitHub de backup..."
      wget -qO- "$FALLBACK_INSTALLER" | bash -s -- $extra_flags
    fi
  fi
  ok "Instalação do Hermes Agent finalizada."
}

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/.hermes/hermes-agent/venv/bin:$HOME/.hermes/hermes-agent/.venv/bin:$PATH"
}

run_setup() {
  refresh_path
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei o comando hermes nesta sessão ainda."
    warn "Abra um novo terminal ou rode: source ~/.bashrc (ou source ~/.zshrc) e depois: hermes setup"
    return 0
  fi

  if confirm "Deseja abrir agora o assistente oficial de configuração (hermes setup)?"; then
    step "Abrindo assistente de configuração oficial do Hermes"
    hermes setup || hermes model
  else
    warn "Sem problemas. Depois rode: hermes setup"
  fi
}

run_doctor() {
  refresh_path
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei hermes para diagnóstico. Abra um novo terminal e rode: hermes doctor"
    return 0
  fi

  step "Rodando diagnóstico de saúde do Hermes (hermes doctor)"
  hermes doctor
}

run_dashboard() {
  refresh_path
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei o comando hermes. Abra um novo terminal e rode: hermes dashboard"
    return 1
  fi

  step "Iniciando Hermes Web Dashboard em http://127.0.0.1:9119"
  (sleep 2 && (xdg-open "http://127.0.0.1:9119" 2>/dev/null || open "http://127.0.0.1:9119" 2>/dev/null || true)) &
  hermes dashboard
}

run_gateway_setup() {
  refresh_path
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei o comando hermes nesta sessão."
    warn "Abra um novo terminal e rode: hermes gateway setup"
    return 0
  fi

  if [ -f "$DOCS_DIR/README.md" ]; then
    printf '\nAntes de configurar o Telegram, leia o guia desta pasta se precisar:\n'
    printf '  %s\n' "$DOCS_DIR/README.md"
  fi

  if ! confirm "Você já possui o token do BotFather e o seu ID numérico do Telegram?"; then
    warn "Sem problemas. Quando tiver os dados, rode no terminal: hermes gateway setup"
    return 0
  fi

  step "Abrindo assistente do Gateway Multicanal (hermes gateway setup)"
  hermes gateway setup

  if confirm "Deseja iniciar o serviço do Gateway agora?"; then
    step "Iniciando gateway"
    hermes gateway start || {
      warn "Se 'gateway start' não rodar em background no seu sistema, execute:"
      warn "  hermes gateway run"
    }
  fi
}

printf '\n\033[0;36m==========================================================\033[0m\n'
printf '\033[1;36m         HERMES AGENT • NOUS RESEARCH (2026)              \033[0m\n'
printf '\033[0;36m==========================================================\033[0m\n'
printf 'Assistente autônomo com criação dinâmica de ferramentas e memória.\n'
printf 'Hermes Easy Installer • Desenvolvido por Daniel Moreira (Moreira Labs)\n'
printf 'Nenhuma credencial fica salva neste pacote de instalação.\n'

if [ "$START_DASHBOARD" -eq 1 ]; then
  run_dashboard
  exit 0
fi

if [ "$SKIP_INSTALL" -eq 0 ]; then
  if confirm "Deseja continuar com o download e instalação oficial do Hermes Agent?"; then
    run_official_installer
  else
    warn "Instalação cancelada pelo usuário."
    exit 0
  fi
fi

refresh_path

if [ "$SKIP_SETUP" -eq 0 ] && [ "$NON_INTERACTIVE" -eq 0 ]; then
  run_setup
fi

if [ "$SKIP_DOCTOR" -eq 0 ]; then
  run_doctor
fi

if [ "$SKIP_GATEWAY_SETUP" -eq 0 ] && [ "$NON_INTERACTIVE" -eq 0 ]; then
  run_gateway_setup
fi

step "Instalação Concluída!"
printf 'Para conversar com o Hermes a qualquer momento no terminal:\n'
printf '  \033[1;32mhermes\033[0m\n\n'
printf 'Para abrir o Hermes Web Dashboard (painel no navegador):\n'
printf '  \033[1;36mhermes dashboard\033[0m\n\n'
printf 'Para alterar configurações, modelos ou chaves de API:\n'
printf '  \033[1;32mhermes setup\033[0m\n'
printf '\nPara gerenciar gateways do Telegram/Discord:\n'
printf '  \033[1;32mhermes gateway status\033[0m\n'
printf '  \033[1;32mhermes gateway start\033[0m\n\n'
