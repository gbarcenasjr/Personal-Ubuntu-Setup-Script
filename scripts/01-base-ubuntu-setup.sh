#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "[1/7] Updating system..."
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y

echo "[2/7] Enabling universe repo and installing base packages..."
sudo add-apt-repository universe -y
sudo apt update
sudo apt install -y \
  flatpak \
  gnome-software-plugin-flatpak \
  fonts-firacode \
  gparted \
  git \
  curl \
  wget \
  zram-tools

fc-cache -f -v

echo "[3/7] Removing Snap safely..."
if command -v snap >/dev/null 2>&1; then
  for pkg in firefox snap-store thunderbird firmware-updater snapd-desktop-integration gtk-common-themes gnome-42-2204 core20 core core22 bare snapd; do
    if snap list "$pkg" >/dev/null 2>&1; then
      sudo snap remove "$pkg" || true
    fi
  done
fi

sudo apt purge -y snapd || true
rm -rf "$HOME/snap"
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd

echo -e "Package: snapd\nPin: release a=*\nPin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null

echo "[4/7] Configuring Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "[5/7] Removing Ubuntu telemetry-related packages..."
sudo apt purge -y ubuntu-report popularity-contest apport whoopsie ubuntu-advantage-tools || true
sudo chmod -x /etc/update-motd.d/* || true

sudo tee /etc/apt/apt.conf.d/99disable-pro >/dev/null <<EOF
APT::Get::Show-User-Simulation-Note "false";
APT::Cmd::Disable-Script-Warning "true";
EOF

echo "[6/7] Applying optimization settings..."

# Limit journal logs
sudo mkdir -p /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/size-limit.conf >/dev/null <<EOF
[Journal]
SystemMaxUse=200M
SystemMaxFileSize=50M
RuntimeMaxUse=50M
EOF

sudo systemctl restart systemd-journald
sudo journalctl --vacuum-size=200M || true

# Enable zswap safely
if ! grep -q 'zswap.enabled=1' /etc/default/grub; then
  sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="zswap.enabled=1 zswap.compressor=zstd zswap.max_pool_percent=25 /' /etc/default/grub
fi
sudo update-grub

# Enable zram
sudo systemctl enable --now zramswap.service

# Memory tuning
sudo tee /etc/sysctl.d/99-memory-tuning.conf >/dev/null <<EOF
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF
sudo sysctl --system

# Enable TRIM for SSD/NVMe
sudo systemctl enable --now fstrim.timer

# APT behavior tweaks
sudo tee /etc/apt/apt.conf.d/99parallel-downloads >/dev/null <<EOF
Acquire::Retries "3";
Acquire::http::Pipeline-Depth "0";
Acquire::Queue-Mode "access";
APT::Acquire::Retries "3";
Acquire::Languages "none";
EOF

# systemd-resolved cache
if systemctl is-enabled systemd-resolved >/dev/null 2>&1 || systemctl is-active systemd-resolved >/dev/null 2>&1; then
  sudo mkdir -p /etc/systemd/resolved.conf.d
  sudo tee /etc/systemd/resolved.conf.d/cache.conf >/dev/null <<EOF
[Resolve]
Cache=yes
DNSStubListener=yes
EOF
  sudo systemctl restart systemd-resolved
fi

echo "[7/7] Cleanup..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Base Ubuntu setup complete. Reboot recommended."
