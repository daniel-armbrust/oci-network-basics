#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/dhcp_options.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_dhcp_id="$(get_dhcp_id "$VCN_A_DHCP_NAME" "$vcn_a_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_a_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"