#!/bin/bash

# Configuração das interfaces de rede
/usr/bin/oci-network-config configure

# Tabela de Rotas da Internet
if [ -z "`grep internet /etc/iproute2/rt_tables`" ]; then
   echo '500 internet' >> /etc/iproute2/rt_tables
fi

# Tabela de Rotas da Rede Externa
if [ -z "`grep externo /etc/iproute2/rt_tables`" ]; then
   echo '600 externo' >> /etc/iproute2/rt_tables
fi

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
vnic_internet_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vnic-internet-ip`"
vnic_internet_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-publica-subnpub1-ip-gw`"
vnic_internet_iface="`ip -o -f inet addr show | grep "$vnic_internet_ip" | awk '{print $2}'`"

# VCN-APPL-1, VCN-APPL-2
vcn_appl_1_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-appl-1-cidr`"
vcn_appl_2_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/vcn-appl-2-cidr`"

# Rede On-Premises
onpremises_internet_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-internet-cidr`"
onpremises_rede_app_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-rede-app-cidr`"
onpremises_rede_backup_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-rede-backup-cidr`"

# Parâmetros do Kernel
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

echo 0 > /proc/sys/net/ipv4/conf/$vnic_appl_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$vnic_internet_iface/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$vnic_externo_iface/rp_filter

echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter

iptables -t filter -F
iptables -t filter -X
iptables -t filter -Z

iptables -t mangle -F
iptables -t mangle -X
iptables -t mangle -Z

iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z

# Evita que o range link-local seja roteado para a Internet
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -s $vnic_appl_ip -d 169.254.0.0/16 -j RETURN

# NAT para a INTERNET
iptables -t nat -A POSTROUTING -o $vnic_internet_iface -j MASQUERADE

#------------------#
# Tabela Principal #
#------------------#

iptables -t mangle -A OUTPUT -o $vnic_appl_iface -d $vcn_fw_interno_cidr -j RETURN
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -d $vcn_appl_1_cidr -j RETURN
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -d $vcn_appl_2_cidr -j RETURN

ip route add $onpremises_internet_cidr via $vnic_externo_ip dev $vnic_externo_iface
ip route add $onpremises_rede_app_cidr via $vnic_externo_ip dev $vnic_externo_iface
ip route add $onpremises_rede_backup_cidr via $vnic_externo_ip dev $vnic_externo_iface

#----------------#
# Tabela Externo #
#----------------#

iptables -t mangle -A OUTPUT -o $vnic_externo_iface -j MARK --set-mark 3000
iptables -t mangle -A OUTPUT -o $vnic_externo_iface -j RETURN

# Permite que as VCNs das aplicações acessem as redes On-Premises.
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d $onpremises_internet_cidr -j MARK --set-mark 3000
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d $onpremises_internet_cidr -j RETURN

iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d $onpremises_internet_cidr -j MARK --set-mark 3000
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d $onpremises_internet_cidr -j RETURN

iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d $onpremises_rede_app_cidr -j MARK --set-mark 3000
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d $onpremises_rede_app_cidr -j RETURN

iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d $onpremises_rede_app_cidr -j MARK --set-mark 3000
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d $onpremises_rede_app_cidr -j RETURN

iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d $onpremises_rede_backup_cidr -j MARK --set-mark 3000
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d $onpremises_rede_backup_cidr -j RETURN

iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d $onpremises_rede_backup_cidr -j MARK --set-mark 3000
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d $onpremises_rede_backup_cidr -j RETURN

ip route add default via $vnic_externo_ip_gw dev $vnic_externo_iface table externo
ip rule add from $vnic_externo_ip fwmark 3000 lookup externo priority 3000
ip rule add fwmark 3000 lookup externo priority 3001

#-----------------#
# Tabela Internet #
#-----------------#

iptables -t mangle -A OUTPUT -o $vnic_internet_iface -j MARK --set-mark 3060
iptables -t mangle -A OUTPUT -o $vnic_internet_iface -j RETURN

# Permite que as VCNs das aplicações acessem a Internet.
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d 0.0.0.0/0 -j MARK --set-mark 3060
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_1_cidr -d 0.0.0.0/0 -j RETURN

iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d 0.0.0.0/0 -j MARK --set-mark 3060
iptables -t mangle -A PREROUTING -i $vnic_appl_iface -s $vcn_appl_2_cidr -d 0.0.0.0/0 -j RETURN

# Permite que o firewall tenha acesso à Internet.
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -s $vnic_appl_ip -d 0.0.0.0/0 -j MARK --set-mark 3060
iptables -t mangle -A OUTPUT -o $vnic_appl_iface -s $vnic_appl_ip -d 0.0.0.0/0 -j RETURN

ip route add default via $vnic_internet_ip_gw dev $vnic_internet_iface table internet
ip rule add from $vnic_internet_ip fwmark 3060 lookup internet priority 3060 
ip rule add fwmark 3060 lookup internet priority 3061

exit 0