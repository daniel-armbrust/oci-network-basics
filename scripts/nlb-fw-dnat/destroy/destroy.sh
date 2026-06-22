#!/bin/bash
set -euo pipefail

# IAM
./iam.sh

# NLB
./nlb.sh

# Reserva de IPv4 Público
./reserved_pub_ip.sh

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

# Object Storage
./objectstorage.sh

exit 0
