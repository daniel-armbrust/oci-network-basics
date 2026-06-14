#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#----------------------#
# VCN-A / DHCP_OPTIONS #
#----------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network dhcp-options create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_DHCP_NAME" \
    --options '[{
        "type": "DomainNameServer",
        "serverType": "VcnLocalPlusInternet"
    }]' \
    --wait-for-state "AVAILABLE"