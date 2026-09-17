#!/bin/bash
cat << 'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
address 10.71.2.2
netmask 255.255.255.0
gateway 10.71.2.1
up echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
/etc/init.d/networking restart

apt-get update
apt-get install -y vsftpd busybox-extras socat net-tools

# Konfigurasi Direktori dan User FTP
mkdir -p /var/wired/data
chown root:root /var/wired/data
chmod 777 /var/wired/data

for u in alice mika eiri; do
    id -u $u &>/dev/null || useradd -m -d /var/wired/data -s /bin/bash $u
    echo "$u:password" | chpasswd
done

# Konfigurasi vsftpd
echo "eiri" > /etc/vsftpd.user_list
chmod 644 /etc/vsftpd.user_list

mkdir -p /etc/vsftpd_user_conf
echo "write_enable=NO" > /etc/vsftpd_user_conf/mika
echo "write_enable=YES" > /etc/vsftpd_user_conf/alice

cat << 'EOF' > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_root=/var/wired/data
userlist_enable=YES
userlist_file=/etc/vsftpd.user_list
userlist_deny=YES
user_config_dir=/etc/vsftpd_user_conf
EOF
service vsftpd restart

# Konfigurasi User dan Service Telnet
id -u phantom_user &>/dev/null || useradd -m -s /bin/bash phantom_user
echo "phantom_user:wired_ghost" | chpasswd

pkill telnetd || true
pkill socat || true
if command -v busybox-extras &> /dev/null; then
    busybox-extras telnetd -p 23 -l /bin/login &
else
    socat TCP-LISTEN:23,reuseaddr,fork EXEC:"/bin/login",pty,stderr,setsid,sigint,sane &
fi

echo "[+] Setup Chisa selesai."