#!/bin/bash

# This script will harden the system through security updates and the installation
# of security software, as well as the implementation of various secure firewall
# rules. In addition, softwares that check for system vulnerabilities will be run
# and their outputs saved to corresponding files.

aptstuff(){ # Some basic, but important apt commands

read -p "Running apt updates... [ENTER]"

apt install -y firefox
apt -V -y install hardinfo chkrootkit iptables portsentry lynis clamav libpam-tmpdir fail2ban needrestart libpam-pwquality

apt -V -y install --reinstall coreutils

apt update
apt upgrade
apt dist-upgrade
}

firewall(){ # Firewall stuff (UFW config)

echo
read -p "Configuring firewall (ufw)... [ENTER]"

apt install ufw
ufw enable

ufw allow ssh
ufw allow http
ufw deny 23
ufw deny 2049
ufw deny 515
ufw deny 111
ufw default deny

ufw status verbose
}

ipt(){ # IPtables stuff (Block spammed SSH attempts, block IPs that portscan, etc.)

echo
read -p "Configuring additional IPTables firewall rules... [ENTER]"
iptables -F

# Block SSH spammers
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 60 --hitcount 5 -j DROP

# Portscan blocker
iptables -A INPUT -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP

# Remove block after a day
iptables -A INPUT -m recent --name portscan --remove
iptables -A FORWARD -m recent --name portscan --remove

# Adding scanners to portscan list, logging scan attempt
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

# Drop NULL packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Drop ping
iptables -A OUTPUT -p icmp -o eth0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -s 0/0 -i eth0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -s 0/0 -i eth0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -s 0/0 -i eth0 -j ACCEPT
iptables -A INPUT -p icmp -i eth0 -j DROP

# Extra
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 23 -j DROP #Block Telnet
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 2049 -j DROP #Block NFS
iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 2049 -j DROP #Block NFS
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 6000:6009 -j DROP #Block X-Windows
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 7100 -j DROP #Block X-Windows font server
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 515 -j DROP #Block printer port
iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 515 -j DROP #Block printer port
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 111 -j DROP #Block Sun rpc/NFS
iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 111 -j DROP #Block Sun rpc/NFS
iptables -A INPUT -p all -s localhost -i eth0 -j DROP #Deny outside packets from internet which claim to be from your loopback interface.


# Save IPtables rules
iptables-save
/sbin/iptables-save
}

configfix(){ #Fix config files

echo
read -p "Replacing configuration files with secure equivalents (sysctl, pam.d, etc.)... [ENTER]"

# Replace /etc/sysctl.conf with a more secure version (Reboots on OOM)
cp sysctl.conf /etc/sysctl.conf
sysctl -p

# Update password rules (pam.d, login.defs)
cp common-password /etc/pam.d/common-password
cp login.defs /etc/login.defs

# Disable guest user
/usr/lib/lightdm/lightdm-set-defaults -l false
}

extrafun(){ #Gathers potentially useful information

echo
read -p "Gathering information on potential security vulnerabilities... [ENTER]"

mkdir output
chkrootkit | tee ./output/chkrootkit.out
lynis audit system | tee ./output/lynis.out
}

if [ "$(id -u)" != "0" ]; then
echo "You are not running harden.bash as root."
echo "Run as 'sudo bash harden.bash'"
exit
else
aptstuff
firewall
ipt
configfix
extrafun

echo
echo "A system restart may be required to finalize changes. In addition, some systems have experienced firewall issues after running this script without a reboot."
fi