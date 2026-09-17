#!/bin/bash
cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
address 10.71.1.2
netmask 255.255.255.0
gateway 10.71.1.1
up echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
/etc/init.d/networking restart

apt-get update
apt-get install -y ftp netcat-openbsd curl

echo "Ini sinyal rahasia dari Alice" > /root/signal_alice.txt

echo "[+] Setup Alice selesai."