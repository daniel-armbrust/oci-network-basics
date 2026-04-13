#!/bin/bash
set -euo pipefail

# Compute Instance
./compute.sh

# DRG
./drg.sh

# Sub-redes
./subnet.sh

# DHCP Options
./dhcp_options.sh

# Security List
./security_list.sh

# Route Table
./route_table.sh

# Gateways de Comunicação
./gateway.sh

# VCN
./vcn.sh

exit 0