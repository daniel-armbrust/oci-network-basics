#!/bin/bash
set -euo pipefail

# IAM
./iam.sh

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

# DRG
./drg.sh

# Reserva de IPv4 Público
./reserved_pub_ip.sh

# Object Storage
./objectstorage.sh

# Object File
./objectfile.sh

# Compute Instance
./compute.sh

# Network Load Balancer
./nlb.sh

# Route Rules
./route_rules.sh

exit 0