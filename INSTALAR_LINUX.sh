#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo
echo "Hermes Easy Installer"
echo
echo "Este instalador usa o script oficial mais recente do Hermes Agent"
echo "da Nous Research para Linux, WSL2 ou Termux."
echo
echo "Nenhuma credencial fica salva neste projeto."
echo

bash "./_motor/install-hermes-easy.sh"
