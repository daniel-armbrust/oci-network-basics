#!/bin/bash

dnf -y install git

# OCI CLI
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" -- \
     --accept-all-defaults

# ArmFirewall Setup
lan_iface="$(ip route | grep default | awk '{print $5}')"

cd /opt && git clone https://github.com/daniel-armbrust/armfirewall-proj.git
cd armfirewall-proj/bin && ./install.sh --lan-iface "$lan_iface"

# Baixa arquivo contendo os endereços IPs públicos das instâncias
oci os object get \
    --bucket-name armfw-data \
    --name armfw-data.txt \
    --file /tmp/armfw-data.txt \
    --auth instance_principal

exit 0