#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"

oci network dhcp-options create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_id" \
    --display-name "$VCN_DHCP_NAME" \
    --options '[{
        "type": "DomainNameServer",
        "serverType": "VcnLocalPlusInternet"
    }]' \
    --wait-for-state "AVAILABLE"