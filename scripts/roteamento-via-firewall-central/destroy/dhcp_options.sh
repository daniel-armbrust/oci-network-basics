#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/dhcp_options.sh"

#----------------------#
# VCN-A / DHCP_OPTIONS #
#----------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_dhcp_id="$(get_dhcp_id "$VCN_A_DHCP_NAME" "$vcn_a_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_a_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"

#----------------------#
# VCN-B / DHCP_OPTIONS #
#----------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_dhcp_id="$(get_dhcp_id "$VCN_B_DHCP_NAME" "$vcn_b_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_b_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"

#-----------------------------#
# VCN-FIREWALL / DHCP_OPTIONS #
#-----------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_dhcp_id="$(get_dhcp_id "$VCN_FIREWALL_DHCP_NAME" "$vcn_firewall_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_firewall_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"