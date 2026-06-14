#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

#----------------#
# VCN-A Gateways #
#----------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network internet-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$IGW_NAME" \
    --is-enabled true \
    --wait-for-state "AVAILABLE"