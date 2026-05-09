#!/bin/bash

# Cria diretório "/etc/iproute2" se não existir
test ! -d /etc/iproute2 && mkdir /etc/iproute2

# Tabela de Rotas da Rede Externa
if [ -z "`grep externo /etc/iproute2/rt_tables 2>/dev/null`" ]; then
   echo '50 externo' >> /etc/iproute2/rt_tables
fi

# Tabela de Rotas da Internet
if [ -z "`grep internet /etc/iproute2/rt_tables 2>/dev/null`" ]; then
   echo '60 internet' >> /etc/iproute2/rt_tables
fi

#-------------------------#
# Inicia o Policy Routing #
#-------------------------#

# Remove todas as regras existentes e recria as regras padrão
ip rule flush
ip rule add priority 0     from all lookup local
ip rule add priority 32766 from all lookup main
ip rule add priority 32767 from all lookup default

# Remove da tabela "main" as rotas referentes às redes VCN-EXTERNO e VCN-INTERNET
ip route del 10.80.30.0/24 dev $vnic_externo_iface 
ip route del 10.90.20.0/24 dev $vnic_internet_iface

# Qualquer comunicação com a rede link-local deve utilizar a Primary VNIC
ip rule add to 169.254.0.0/16 table main prio 10

#-----------#
# Variáveis #
#-----------#

# VNIC - VCN-FIREWALL-INTERNO
vcn_fw_interno_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-fw-interno-cidr`"
vnic_appl_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-appl-ip`"
vnic_appl_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-fw-interno-subnprv1-ip-gw`"
vnic_appl_iface="`ip -o -f inet addr show | grep "$vnic_appl_ip" | awk '{print $2}'`"

# VNIC - VCN-FIREWALL-EXTERNO
vcn_fw_externo_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-fw-externo-cidr`"
vnic_externo_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-externo-ip`"
vnic_externo_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-fw-externo-subnprv1-ip-gw`"
vnic_externo_iface="`ip -o -f inet addr show | grep "$vnic_externo_ip" | awk '{print $2}'`"

# VNIC - VCN-PUBLICA
vcn_publica_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-publica-cidr`"
vnic_internet_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-internet-ip`"
vnic_internet_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-publica-subnpub1-ip-gw`"
vnic_internet_iface="`ip -o -f inet addr show | grep "$vnic_internet_ip" | awk '{print $2}'`"

# VCN-APPL-1, VCN-APPL-2, VCN-DB
vcn_appl_1_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-appl-1-cidr`"
vcn_appl_2_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-appl-2-cidr`"
vcn_db_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-db-cidr`"

# Rede On-Premises
onpremises_internet_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-internet-cidr`"
onpremises_rede_app_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-rede-app-cidr`"
onpremises_rede_backup_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-rede-backup-cidr`"

#----------------------#
# VCN-FIREWALL-INTERNO #
#----------------------#
# ip rule add to $vcn_fw_interno_cidr table main prio 20
# ip rule add from $vcn_fw_interno_cidr table main prio 21

#----------------------#
# VCN-FIREWALL-EXTERNO #
#----------------------#
ip route replace $vcn_fw_externo_cidr dev $vnic_externo_iface table externo
ip route replace default via $vnic_externo_ip_gw table externo

ip rule add to $vcn_fw_externo_cidr table externo prio 30
ip rule add from $vcn_fw_externo_cidr table externo prio 31

# Redes on-premises
ip rule add to $onpremises_internet_cidr table externo prio 32
ip rule add to $onpremises_rede_app_cidr table externo prio 33
ip rule add to $onpremises_rede_backup_cidr table externo prio 34

#---------------------------------#
# VCN-APPL-1, VCN-APPL-2 e VCN-DB #
#---------------------------------#
ip route replace $vcn_db_cidr dev $vnic_appl_iface table main

ip rule add to $vcn_appl_1_cidr table main prio 40
ip rule add to $vcn_appl_2_cidr table main prio 41
ip rule add to $vcn_db_cidr table main prio 42

#-------------------------------#
# VCN-PUBLICA (internet in/out) #
#-------------------------------#
ip route replace $vcn_publica_cidr dev $vnic_internet_iface table internet
ip route replace default via $vnic_internet_ip_gw table internet

ip rule add to $vcn_publica_cidr table internet prio 50
ip rule add from $vcn_publica_cidr table internet prio 51

#---------------------#
# Saída para Internet #
#---------------------#
ip rule add to 0.0.0.0/0 table internet prio 200

# Limpa a cache das rotas do Kernel
ip route flush cache

#----------------------#
# Parâmetros do Kernel #
#----------------------#
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

echo 0 > /proc/sys/net/ipv4/conf/$vnic_appl_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$vnic_internet_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$vnic_externo_iface/rp_filter

echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter

# NAT para a Internet
iptables -t nat -A POSTROUTING -o $vnic_internet_iface -j MASQUERADE

exit 0