#!/bin/bash

# Ajuste do TimeZone para "America/Sao_Paulo"
#/usr/bin/timedatectl set-timezone America/Sao_Paulo

# Atualiza, Instala e remove pacotes do Sistema Operacional
#/usr/bin/dnf -y update
/usr/bin/dnf -y install traceroute net-tools python39-oci-cli iptraf-ng
/usr/bin/dnf -y remove setroubleshoot-server

# Desabilita o SELinux
setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Desabilita o Firewall do Sistema Operacional
/usr/bin/systemctl disable --now firewalld

# Habilita o daemon OCID
# https://docs.oracle.com/en-us/iaas/oracle-linux/oci-utils/index.htm#oci-network-config__config_vnic
# /usr/bin/systemctl enable --now ocid.service

# Aumenta o tamanho do boot volume
/usr/libexec/oci-growfs -y

# Cria o arquivo rc.local
cat <<EOF >/etc/rc.d/rc.local
#!/bin/bash

# Download do script de configuração das VNICs
oci --auth instance_principal os object get --bucket-name scripts-storage --name vm-firewall_config-vnics.sh --file /etc/config-vnics.sh

# Execução do script de configuração das VNICs
bash -x /etc/config-vnics.sh &>/var/log/config-vnics.out

# Download do script de configuração do Firewall e Policy Routing
oci --auth instance_principal os object get --bucket-name scripts-storage --name vm-firewall_rc-firewal.sh --file /etc/rc-firewall.sh

# Execução do script de configuração do Firewall e Policy Routing
bash -x /etc/rc-firewall.sh &>/var/log/rc-firewall.out

# From /etc/rc.local
touch /var/lock/subsys/local
EOF

# Start and enable the rc-local service
chmod +x /etc/rc.d/rc.local
systemctl start rc-local
systemctl enable rc-local

exit 0