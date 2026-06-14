#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_a_id")"

oci network internet-gateway delete \
    --ig-id "$vcn_a_igw_id" \
    --wait-for-state "TERMINATED" \
    --force