#!/bin/bash
cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
address 10.71.3.3
netmask 255.255.255.0
gateway 10.71.3.1
up echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
/etc/init.d/networking restart

apt-get update
apt-get install -y ftp telnet

echo "[+] Setup Eiri selesai."