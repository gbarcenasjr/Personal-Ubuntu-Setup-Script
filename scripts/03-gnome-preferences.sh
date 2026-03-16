#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Applying GNOME appearance settings..."

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark' || true
gsettings set org.gnome.desktop.session idle-delay 900 || true

echo "[2/4] Disabling SSH key agent autostart..."
mkdir -p "$HOME/.config/autostart"
if [ -f /etc/xdg/autostart/gnome-keyring-ssh.desktop ]; then
  cp /etc/xdg/autostart/gnome-keyring-ssh.desktop "$HOME/.config/autostart/"
  if ! grep -q '^X-GNOME-Autostart-enabled=false$' "$HOME/.config/autostart/gnome-keyring-ssh.desktop"; then
    echo "X-GNOME-Autostart-enabled=false" >> "$HOME/.config/autostart/gnome-keyring-ssh.desktop"
  fi
fi

echo "[3/4] Refreshing font cache..."
fc-cache -f -v

echo "[4/4] GNOME preferences applied."
echo "Log out and back in if some settings do not appear immediately."
