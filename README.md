# Ubuntu Setup (For Myself)

***By Gerardo Barcenas***

A personal Ubuntu post-install setup script for quickly configuring a fresh system with my preferred settings.

This setup focuses on:

- removing Snap
- enabling Flatpak + Flathub
- reducing Ubuntu telemetry
- applying system optimizations
- setting GNOME preferences
- installing common applications

---

# Features

## Base System Configuration

The base setup script performs the following:

- Updates and upgrades Ubuntu packages
- Enables the `universe` repository
- Installs essential packages:

```
flatpak
gnome-software-plugin-flatpak
fonts-firacode
gparted
git
curl
wget
zram-tools
```

---

# Snap Removal

The script removes Snap from Ubuntu to avoid Snap packages and use Flatpak instead.

Steps include:

- Removes common Snap applications if present
- Purges `snapd`
- Deletes leftover Snap directories
- Prevents Snap from reinstalling by pinning `snapd`

---

# Flatpak Setup

Flatpak is installed and configured with the Flathub repository.

Applications installed via Flatpak:

```
Brave Browser
RustDesk
VSCodium
Obsidian
```

Flathub is added as the primary application repository.

---

# Telemetry Reduction

The script removes or disables common Ubuntu telemetry components:

Removed packages:

```
ubuntu-report
popularity-contest
apport
whoopsie
ubuntu-advantage-tools
```

Additional changes:

- disables MOTD scripts
- suppresses Ubuntu Pro related APT messages

---

# System Optimization

Several system performance improvements are applied.

### Logging

System logs are limited to prevent large disk usage.

```
journald max size: 200MB
log rotation enabled
```

### Memory Management

- Enables **zswap**
- Enables **zram**

Additional memory tuning:

```
vm.swappiness = 10
vm.vfs_cache_pressure = 50
```

### Disk Maintenance

Enables automatic SSD/NVMe TRIM:

```
fstrim.timer
```

### APT Improvements

APT configuration is adjusted for better behavior:

- retry downloads automatically
- reduce unnecessary language downloads

### DNS

If available, the system enables caching in:

```
systemd-resolved
```

---

# GNOME Desktop Preferences

The GNOME configuration script applies the following:

Appearance:

```
Dark Mode
Yaru-dark GTK theme
```

Desktop behavior:

```
Screen idle timeout: 15 minutes
```

Startup behavior:

- disables GNOME SSH key agent auto-start

---

# Repository Structure

```
ubuntu-setup/
├── README.md
├── LICENSE
├── .gitignore
├── install.sh
└── scripts/
    ├── 01-base-ubuntu-setup.sh
    ├── 02-apps-install.sh
    └── 03-gnome-preferences.sh
```

---

# Usage

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/ubuntu-setup.git
cd ubuntu-setup
```

Make scripts executable:

```bash
chmod +x install.sh scripts/*.sh
```

Run the full setup:

```bash
./install.sh
```

---

# Running Individual Scripts

You can also run scripts separately.

Base system configuration:

```bash
./scripts/01-base-ubuntu-setup.sh
```

Install applications:

```bash
./scripts/02-apps-install.sh
```

Apply GNOME preferences:

```bash
./scripts/03-gnome-preferences.sh
```

---

# Notes

- GNOME preference settings should be run while logged into a GNOME session.
- Some changes require a reboot to fully apply.
- Review scripts before running on production machines.
- The configuration is opinionated and designed for personal use.

---

# Recommended After Install

```
reboot
```

---

# License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

See the `LICENSE` file for details.

