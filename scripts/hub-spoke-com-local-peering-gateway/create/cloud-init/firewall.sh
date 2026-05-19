#!/bin/bash

/usr/bin/dnf install -y git jq

# Retorna a interface primária
mac="$(curl -s -H 'Authorization: Bearer Oracle' http://169.254.169.254/opc/v2/vnics/ | jq -r '.[0].macAddr' | tr '[:upper:]' '[:lower:]')" 
primary_iface="$([ -n "$mac" ] && ip -o link show | awk -v mac="$mac" 'tolower($0) ~ mac {gsub(":", "", $2); print $2; exit}')"

# ArmFirewall deployment 
cd /opt && git clone https://github.com/daniel-armbrust/armfirewall-proj.git && cd armfirewall-proj/bin
./install.sh --lan-iface $primary_iface --wan-iface $primary_iface --router-mode

exit 0