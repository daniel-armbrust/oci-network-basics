#!/bin/bash
set -euo pipefail

# IAM
./iam.sh

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

# Reserved public IPv4
./reserved_pub_ip.sh

# Object Storage
./objectstorage.sh

exit 0