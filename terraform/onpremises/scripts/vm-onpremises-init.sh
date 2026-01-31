#!/bin/bash

# Ajuste do TimeZone para "America/Sao_Paulo"
#/usr/bin/timedatectl set-timezone America/Sao_Paulo

# Atualiza, Instala e remove pacotes do Sistema Operacional
#/usr/bin/dnf -y update
/usr/bin/dnf -y install traceroute net-tools python39-oci-cli libreswan ncurses-devel readline-devel
/usr/bin/dnf -y groupinstall "Development Tools"
/usr/bin/dnf -y remove setroubleshoot-server

# Desabilita o SELinux
setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Desabilita o Firewall do Sistema Operacional
/usr/bin/systemctl stop firewalld
/usr/bin/systemctl disable firewalld

# Habilita o daemon OCID
# https://docs.oracle.com/en-us/iaas/oracle-linux/oci-utils/index.htm#oci-network-config__config_vnic
/usr/bin/systemctl enable --now ocid.service

# Aumenta o tamanho do boot volume
/usr/libexec/oci-growfs -y

# BIRD - BGP Daemon
# https://bird.network.cz/
/usr/bin/wget https://bird.network.cz/download/bird-3.1.2.tar.gz
/usr/bin/tar zxvf bird-3.1.2.tar.gz
cd bird-3.1.2/ && ./configure && make install && cd - && rm -rf bird-3.1.2/

# Cria o arquivo rc.local
cat <<EOF >/etc/rc.d/rc.local
#!/bin/bash

# Download do script de configuração do IP Público Reservado.
oci --auth instance_principal os object get --bucket-name scripts-storage --name ip-public-setup.sh --file /etc/ip-public-setup.sh

# Download do script de configuração do Firewall e Policy Routing.
oci --auth instance_principal os object get --bucket-name scripts-storage --name rc-firewall-vm-ipsec-onpremises.sh --file /etc/rc-firewall.sh

# Download do script de configuração da VPN.
oci --auth instance_principal os object get --bucket-name scripts-storage --name vpn-setup.sh --file /etc/vpn-setup.sh

# Download do script de configuração do BGP.
oci --auth instance_principal os object get --bucket-name scripts-storage --name bgp-setup.sh --file /etc/bgp-setup.sh

# Execução dos scripts
chmod 0500 /etc/rc-firewall.sh
/etc/rc-firewall.sh

chmod 0500 /etc/ip-public-setup.sh
/etc/ip-public-setup.sh

chmod 0500 /etc/vpn-setup.sh
/etc/vpn-setup.sh

chmod 0500 /etc/bgp-setup.sh
/etc/bgp-setup.sh

# From /etc/rc.local
touch /var/lock/subsys/local
EOF

# Start and enable the rc-local service
chmod +x /etc/rc.d/rc.local
systemctl start rc-local
systemctl enable rc-local

exit 0