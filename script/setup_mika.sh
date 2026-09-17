#!/bin/bash
cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
address 10.71.1.3
netmask 255.255.255.0
gateway 10.71.1.1
up echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
/etc/init.d/networking restart

apt-get update
apt-get install -y ftp openssh-client

echo "halo" > /root/test_mika.txt

id -u mika_admin &>/dev/null || useradd -m -s /bin/bash mika_admin
if [ ! -f /home/mika_admin/.ssh/id_rsa ]; then
    su - mika_admin -c 'ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa'
fi

echo "[+] Setup Mika selesai. Kunci publik mika_admin:"
cat /home/mika_admin/.ssh/id_rsa.pub