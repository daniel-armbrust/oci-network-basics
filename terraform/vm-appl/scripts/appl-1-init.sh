#!/bin/sh

# Ajuste do TimeZone para "America/Sao_Paulo"
#/usr/bin/timedatectl set-timezone America/Sao_Paulo

# Atualiza, Instala e remove pacotes do Sistema Operacional
/usr/bin/dnf -y update
/usr/bin/dnf -y install traceroute net-tools python39-oci-cli
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

exit 0