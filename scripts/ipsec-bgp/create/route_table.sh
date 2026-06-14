#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# VCN-A / SUBNPUB - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPUB_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"