#!/bin/bash
set -euo pipefail

# Reserva de endereços IPs privados
./private-ip.sh

# Compute Instance
./compute.sh

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
