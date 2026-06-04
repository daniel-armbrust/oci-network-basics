#!/bin/bash
set -euo pipefail

# IAM
./iam.sh

# Object Storage
./objectstorage.sh

# Reserved public IPv4
./reserved_pub_ip.sh

# Object File (Public IPs)
./objectfile.sh

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

# Route Rules
./route_rules.sh

exit 0