#!/bin/bash
cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
address 10.71.3.2
netmask 255.255.255.0
gateway 10.71.3.1
up echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
/etc/init.d/networking restart

apt-get update
apt-get install -y openssh-server nginx net-tools wget unzip ftp iputils-ping

service nginx start
service ssh start

# Unduh bahan laporan
if [ ! -f /root/knights_report.txt ]; then
    wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1lFepK4wFmx55PnRki3NsHW-ivudSR0vg' -O /root/knights_report.zip
    unzip -o /root/knights_report.zip -d /root/
fi

# Konfigurasi User SSH
id -u mika_admin &>/dev/null || useradd -m -s /bin/bash mika_admin
mkdir -p /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh
chown -R mika_admin:mika_admin /home/mika_admin/.ssh

mkdir -p /run/sshd
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
service ssh restart

echo "[+] Setup Knights selesai. Ingat untuk menambahkan id_rsa.pub Mika ke authorized_keys milik mika_admin."