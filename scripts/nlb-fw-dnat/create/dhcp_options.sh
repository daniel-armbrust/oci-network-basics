#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

oci network dhcp-options create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_frontend_id" \
    --display-name "$VCN_FRONTEND_DHCP_NAME" \
    --options '[{
        "type": "DomainNameServer",
        "serverType": "VcnLocalPlusInternet"
    }]' \
    --wait-for-state "AVAILABLE"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

oci network dhcp-options create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_backend_id" \
    --display-name "$VCN_BACKEND_DHCP_NAME" \
    --options '[{
        "type": "DomainNameServer",
        "serverType": "VcnLocalPlusInternet"
    }]' \
    --wait-for-state "AVAILABLE"