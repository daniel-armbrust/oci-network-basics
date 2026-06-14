#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# Public Subnet
vcn_a_subnpub_id="$(get_subnet_id "$VCN_A_SUBNPUB_NAME" "$vcn_a_id" "$VCN_A_SUBNPUB_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_a_subnpub_id" \
    --force \
    --wait-for-state "TERMINATED"