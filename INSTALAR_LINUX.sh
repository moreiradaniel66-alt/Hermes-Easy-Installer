#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

printf '\n\033[0;36m==========================================================\033[0m\n'
printf '\033[1;36m   HERMES EASY INSTALLER • NOUS RESEARCH (2026)          \033[0m\n'
printf '\033[0;36m==========================================================\033[0m\n'
printf 'Iniciando instalador oficial para Linux / WSL2 / Termux...\n\n'

chmod +x "./_motor/install-hermes-easy.sh"
bash "./_motor/install-hermes-easy.sh" "$@"
