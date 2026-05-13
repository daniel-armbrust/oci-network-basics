#!/bin/bash

/usr/bin/dnf -y install traceroute net-tools tcpdump

# Desabilita o SELinux
setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Desabilita o Firewall do Sistema Operacional
/usr/bin/systemctl disable --now firewalld

# Aumenta o tamanho do boot volume
/usr/libexec/oci-growfs -y

exit 0