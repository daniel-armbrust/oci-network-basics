#!/bin/bash
set -euo pipefail

# IAM
./iam.sh

# Reserved public IPv4
./reserved_pub_ip.sh

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

# Compute Instance
./compute.sh

# VPN Site-To-Site
./vpn.sh

# Route Rules
./route_rules.sh

# Security Rules
./security_rules.sh

# Object Storage
./objectstorage.sh

# Object File (Public IPs)
./objectfile.sh

exit 0