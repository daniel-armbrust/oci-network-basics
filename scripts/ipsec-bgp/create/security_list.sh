#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# VCN-A / SUBNPUB - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPUB_SECL_NAME" \
    --egress-security-rules '[]' \
    --ingress-security-rules "[]" \
    --wait-for-state "AVAILABLE"