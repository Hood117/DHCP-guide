# DHCP-guide
# Linux DHCP Server Setup Script

This script automates the installation and configuration of a DHCP server on a RHEL-based Linux machine (Fedora, CentOS, AlmaLinux, etc.) in a VMware host-only network environment.

## Features

- Installs `dhcp-server` package
- Configures a static IP (manual step via `nmtui`)
- Writes a sample DHCP config for subnet `192.168.206.0/24`
- Enables and starts the DHCP service
- Opens firewall for DHCP
- Restarts NetworkManager

## Requirements

- Root privileges
- `dnf` package manager
- A VM running in **VMware host-only** network mode

## Usage

```bash
chmod +x setup_dhcp_server.sh
sudo ./setup_dhcp_server.sh

