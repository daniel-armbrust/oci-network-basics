#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"

oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_id" \
    --display-name "$SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"