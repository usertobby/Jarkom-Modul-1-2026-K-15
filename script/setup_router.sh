#!/bin/bash
apt-get update
apt-get install -y iptables iproute2 netcat-openbsd

cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
up sysctl -w net.ipv4.ip_forward=1    
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE   

auto eth1
iface eth1 inet static
address 10.71.1.1
netmask 255.255.255.0

auto eth2
iface eth2 inet static
address 10.71.2.1
netmask 255.255.255.0

auto eth3
iface eth3 inet static
address 10.71.3.1
netmask 255.255.255.0
EOF

/etc/init.d/networking restart
echo "[+] Setup Router selesai."