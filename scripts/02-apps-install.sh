#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] Installing Flatpak apps..."
flatpak install -y flathub com.brave.Browser
flatpak install -y flathub com.rustdesk.RustDesk
flatpak install -y flathub com.vscodium.codium
flatpak install -y flathub md.obsidian.Obsidian

echo "[2/3] Applying optional Flatpak overrides..."
flatpak override --user --filesystem=xdg-download --filesystem=xdg-documents com.brave.Browser || true

echo "[3/3] Persisting codium alias..."
if ! grep -q 'alias codium="flatpak run com.vscodium.codium"' "$HOME/.bashrc" 2>/dev/null; then
  echo 'alias codium="flatpak run com.vscodium.codium"' >> "$HOME/.bashrc"
fi

echo "App installation complete."
