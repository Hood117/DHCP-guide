#!/bin/bash

# DHCP Server Setup Script for Host-Only Network (VMware)
# Tested on RHEL-based systems (Fedora, CentOS, Rocky, AlmaLinux)

# Run as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root using: sudo ./setup_dhcp_server.sh"
   exit 1
fi

echo "Installing DHCP server..."
dnf install -y dhcp-server || { echo "Failed to install DHCP server"; exit 1; }

echo "Configuring static IP using nmtui..."
echo "Please manually configure IP address:"
echo "  nmtui > Edit a connection > Edit ens33 > Set Manual IP: 192.168.206.100/24"
echo "  Add gateway, DNS, then activate the connection."
read -p "Press Enter once done..."

echo "Copying default DHCP config..."
cp /usr/share/doc/dhcp-server/dhcpd.conf.example /etc/dhcp/dhcpd.conf

echo "Editing /etc/dhcp/dhcpd.conf..."
echo "Replace subnet with ip address from which you want to assign ip"
echo "Set the range as well."
cat <<EOF > /etc/dhcp/dhcpd.conf
subnet 192.168.206.0 netmask 255.255.255.0 {
  range 192.168.206.10 192.168.206.50;
  option routers 192.168.206.100;
  option domain-name-servers 8.8.8.8;
  default-lease-time 600;
  max-lease-time 7200;
}
EOF

echo "Starting and enabling DHCP service..."
systemctl enable --now dhcpd
systemctl status dhcpd --no-pager

echo "Allowing DHCP service through firewall..."
firewall-cmd --permanent --add-service=dhcp
firewall-cmd --reload
firewall-cmd --list-all | grep dhcp

echo "Restarting NetworkManager..."
systemctl restart NetworkManager
ifup ens33

echo "Please go to VMware > Edit > Virtual Network Editor:"
echo "  - Disable the built-in DHCP server for Host-Only network."
echo "Setup complete!"
