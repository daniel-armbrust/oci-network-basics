#!/bin/bash
set -euo pipefail

# VCN
./vcn.sh

# Gateways de Comunicação
./gateway.sh

# Route Table
./route_table.sh

# Security List
./security_list.sh

# DHCP Options
./dhcp_options.sh

# Sub-redes
./subnet.sh

# Compute Instance
./compute.sh

# DRG
./drg.sh

# Route Rules
./route_rules.sh

exit 0