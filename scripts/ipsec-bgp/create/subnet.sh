#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/security_list.sh"
source "../../lib/dhcp_options.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_dhcp_id="$(get_dhcp_id "$VCN_A_DHCP_NAME" "$vcn_a_id")"

# Public Subnet
vcn_a_subnpub_rt_id="$(get_route_table_id "$VCN_A_SUBNPUB_RT_NAME" "$vcn_a_id")"
vcn_a_subnpub_secl_id="$(get_secl_id "$VCN_A_SUBNPUB_SECL_NAME" "$vcn_a_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --cidr-block "$VCN_A_SUBNPUB_CIDR" \
    --display-name "$VCN_A_SUBNPUB_NAME" \
    --dns-label "$VCN_A_SUBNPUB_DNS_NAME" \
    --dhcp-options-id "$vcn_a_dhcp_id" \
    --route-table-id "$vcn_a_subnpub_rt_id" \
    --security-list-ids "[\"$vcn_a_subnpub_secl_id\"]" \
    --prohibit-public-ip-on-vnic "false" \
    --wait-for-state AVAILABLE