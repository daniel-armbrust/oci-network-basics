#!/bin/bash
set -euo pipefail

# VCN
./vcn.sh

# Gateways de Comunicação
./gateway.sh

# Route Table
./route_table.sh

# Route Rules
./route_rules.sh

# Security List
./security_list.sh

# DHCP Options
./dhcp_options.sh

# Sub-redes
./subnet.sh

# Compute Instance
./compute.sh

# Reserva de endereços IPs privados
./private-ip.sh

# Atribuição de endereços IP privados ao FW1
./fw1-vnic.sh

exit 0