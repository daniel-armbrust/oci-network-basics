#!/bin/bash

# Configuração das interfaces de rede
/usr/bin/oci-network-config configure

# Tabela de Rotas da Internet
if [ -z "`grep app /etc/iproute2/rt_tables`" ]; then
   echo '500 app' >> /etc/iproute2/rt_tables
fi

# Tabela de Rotas da Rede Externa
if [ -z "`grep backup /etc/iproute2/rt_tables`" ]; then
   echo '600 backup' >> /etc/iproute2/rt_tables
fi

pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/pub-ip`"

internet_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-cidr`"
internet_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-ip`"
internet_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-ip-gw`"
internet_iface="`ip -o -f inet addr show | grep "$internet_ip" | awk '{print $2}'`"

rede_app_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-app-cidr`"
rede_app_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-app-ip`"
rede_app_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-app-ip-gw`"
rede_app_iface="`ip -o -f inet addr show | grep "$rede_app_ip" | awk '{print $2}'`"

rede_backup_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-backup-cidr`"
rede_backup_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-backup-ip`"
rede_backup_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-backup-ip-gw`"
rede_backup_iface="`ip -o -f inet addr show | grep "$rede_backup_ip" | awk '{print $2}'`"

# Parâmetros do Kernel
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

echo 0 > /proc/sys/net/ipv4/conf/$internet_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$rede_app_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$rede_backup_iface/rp_filter

echo 0 > /proc/sys/net/ipv4/conf/$internet_iface/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/$rede_app_iface/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/$rede_backup_iface/send_redirects

echo 0 > /proc/sys/net/ipv4/conf/$internet_iface/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/$rede_app_iface/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/$rede_backup_iface/accept_redirects

echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects

# Altera o MTU da VNIC Internet.
ip link set $internet_iface mtu 1500

exit 0