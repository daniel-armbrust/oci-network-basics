#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"

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

#----------------------#
# VCN-B / DHCP_OPTIONS #
#----------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network dhcp-options create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_DHCP_NAME" \
    --options '[{
        "type": "DomainNameServer",
        "serverType": "VcnLocalPlusInternet"
    }]' \
    --wait-for-state "AVAILABLE"

#-----------------------------#
# VCN-FIREWALL / DHCP_OPTIONS #
#-----------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

oci network dhcp-options create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_DHCP_NAME" \
    --options '[{
        "type": "DomainNameServer",
        "serverType": "VcnLocalPlusInternet"
    }]' \
    --wait-for-state "AVAILABLE"