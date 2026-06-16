#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_id" \
    --display-name "$SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"