#!/usr/bin/env bash
set -euo pipefail

OFFICIAL_INSTALLER="https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$(basename "$SCRIPT_DIR")" = "_motor" ]; then
  PACKAGE_ROOT="$(dirname "$SCRIPT_DIR")"
else
  PACKAGE_ROOT="$SCRIPT_DIR"
fi
DOCS_DIR="$PACKAGE_ROOT/Documentacao"

SKIP_INSTALL=0
SKIP_MODEL_SETUP=0
SKIP_GATEWAY_SETUP=0
SKIP_DOCTOR=0
NON_INTERACTIVE=0

for arg in "$@"; do
  case "$arg" in
    --skip-install) SKIP_INSTALL=1 ;;
    --skip-model-setup) SKIP_MODEL_SETUP=1 ;;
    --skip-gateway-setup) SKIP_GATEWAY_SETUP=1 ;;
    --skip-doctor) SKIP_DOCTOR=1 ;;
    --non-interactive) NON_INTERACTIVE=1 ;;
    -h|--help)
      cat <<'HELP'
Hermes Easy Installer

Options:
  --skip-install       Do not run the official installer.
  --skip-model-setup  Do not open "hermes model" after install.
  --skip-gateway-setup Do not open "hermes gateway setup" after install.
  --skip-doctor       Do not run "hermes doctor" after install.
  --non-interactive   Avoid this wrapper's prompts.
  -h, --help          Show this help.
HELP
      exit 0
      ;;
    *)
      echo "[!] Unknown option: $arg" >&2
      exit 2
      ;;
  esac
done

step() {
  printf '\n==> %s\n' "$1"
}

ok() {
  printf '[OK] %s\n' "$1"
}

warn() {
  printf '[!] %s\n' "$1"
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

  echo "Hermes Easy Installer precisa de curl ou wget." >&2
  exit 1
}

run_official_installer() {
  local downloader
  downloader="$(need_downloader)"

  step "Baixando e executando o instalador oficial mais recente do Hermes Agent"
  if [ "$downloader" = "curl" ]; then
    curl -fsSL "$OFFICIAL_INSTALLER" | bash
  else
    wget -qO- "$OFFICIAL_INSTALLER" | bash
  fi
  ok "Instalador oficial concluído"
}

run_model_setup() {
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei o comando hermes nesta sessão."
    warn "Abra um novo terminal e rode: hermes model"
    return 0
  fi

  if confirm "Abrir agora o assistente oficial para escolher modelo/login/API key?"; then
    step "Abrindo assistente oficial do Hermes"
    hermes model
  else
    warn "Tudo bem. Depois rode: hermes model"
  fi
}

run_doctor() {
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei hermes para diagnóstico. Abra um novo terminal e rode: hermes doctor"
    return 0
  fi

  step "Rodando diagnóstico"
  hermes doctor
}

run_gateway_setup() {
  if ! command -v hermes >/dev/null 2>&1; then
    warn "Não encontrei o comando hermes nesta sessão."
    warn "Abra um novo terminal e rode: hermes gateway setup"
    return 0
  fi

  if [ -f "$DOCS_DIR/GUIA_COMPLETO_HERMES_E_TELEGRAM.md" ]; then
    printf '\nAntes de configurar o Telegram, leia o guia desta pasta:\n'
    printf '  %s\n' "$DOCS_DIR/GUIA_COMPLETO_HERMES_E_TELEGRAM.md"
  fi

  if ! confirm "Você já tem o token do BotFather e o seu Telegram User ID?"; then
    warn "Sem problema. Quando tiver os dois, rode: hermes gateway setup"
    return 0
  fi

  step "Abrindo configuração oficial do gateway"
  hermes gateway setup

  if confirm "Iniciar o gateway do Telegram agora?"; then
    step "Iniciando gateway"
    hermes gateway start || {
      warn "Se 'gateway start' não funcionar neste sistema, tente:"
      warn "  hermes gateway"
      warn "ou:"
      warn "  hermes gateway run"
    }
  fi
}

printf '\nHermes Easy Installer\n'
printf 'Instala o Hermes Agent usando os scripts oficiais da Nous Research.\n'
printf 'Credenciais não são salvas por este wrapper; use apenas o assistente oficial.\n'

if [ "$SKIP_INSTALL" -eq 0 ]; then
  if confirm "Continuar e baixar o instalador oficial mais recente?"; then
    run_official_installer
  else
    warn "Instalação cancelada pelo usuário."
    exit 0
  fi
fi

if [ "$SKIP_MODEL_SETUP" -eq 0 ] && [ "$NON_INTERACTIVE" -eq 0 ]; then
  run_model_setup
fi

if [ "$SKIP_DOCTOR" -eq 0 ]; then
  run_doctor
fi

if [ "$SKIP_GATEWAY_SETUP" -eq 0 ] && [ "$NON_INTERACTIVE" -eq 0 ]; then
  run_gateway_setup
fi

step "Pronto"
printf 'Para conversar com o Hermes, abra um novo terminal e rode:\n'
printf '  hermes\n\n'
printf 'Para trocar login/modelo/API key depois:\n'
printf '  hermes model\n'
printf '\nPara configurar Telegram depois:\n'
printf '  hermes gateway setup\n'
