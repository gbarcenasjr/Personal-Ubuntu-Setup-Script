#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/scripts/01-base-ubuntu-setup.sh"
bash "$SCRIPT_DIR/scripts/02-apps-install.sh"
bash "$SCRIPT_DIR/scripts/03-gnome-preferences.sh"

echo "All scripts completed successfully."
echo "Reboot recommended."
