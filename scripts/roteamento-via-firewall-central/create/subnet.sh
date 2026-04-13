#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/route_table.sh"
source "../lib/security_list.sh"
source "../lib/dhcp_options.sh"

#----------------#
# VCN-A / SUBNET #
#----------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_dhcp_id="$(get_dhcp_id "$VCN_A_DHCP_NAME" "$vcn_a_id")"
vcn_a_subnprv_rt_id="$(get_route_table_id "$VCN_A_SUBNPRV_RT_NAME" "$vcn_a_id")"
vcn_a_subnprv_secl_id="$(get_secl_id "$VCN_A_SUBNPRV_SECL_NAME" "$vcn_a_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --cidr-block "$VCN_A_SUBNPRV_CIDR" \
    --display-name "$VCN_A_SUBNPRV_NAME" \
    --dns-label "$VCN_A_SUBNPRV_DNS_NAME" \
    --dhcp-options-id "$vcn_a_dhcp_id" \
    --route-table-id "$vcn_a_subnprv_rt_id" \
    --security-list-ids "[\"$vcn_a_subnprv_secl_id\"]" \
    --prohibit-public-ip-on-vnic "true" \
    --wait-for-state AVAILABLE

#----------------#
# VCN-B / SUBNET #
#----------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_dhcp_id="$(get_dhcp_id "$VCN_B_DHCP_NAME" "$vcn_b_id")"
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"
vcn_b_subnprv_secl_id="$(get_secl_id "$VCN_B_SUBNPRV_SECL_NAME" "$vcn_b_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --cidr-block "$VCN_B_SUBNPRV_CIDR" \
    --display-name "$VCN_B_SUBNPRV_NAME" \
    --dns-label "$VCN_B_SUBNPRV_DNS_NAME" \
    --dhcp-options-id "$vcn_b_dhcp_id" \
    --route-table-id "$vcn_b_subnprv_rt_id" \
    --security-list-ids "[\"$vcn_b_subnprv_secl_id\"]" \
    --prohibit-public-ip-on-vnic "true" \
    --wait-for-state AVAILABLE

#-----------------------#
# VCN-FIREWALL / SUBNET #
#-----------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_dhcp_id="$(get_dhcp_id "$VCN_FIREWALL_DHCP_NAME" "$vcn_firewall_id")"
vcn_firewall_subnprv_rt_id="$(get_route_table_id "$VCN_FIREWALL_SUBNPRV_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_subnprv_secl_id="$(get_secl_id "$VCN_FIREWALL_SUBNPRV_SECL_NAME" "$vcn_firewall_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --cidr-block "$VCN_FIREWALL_SUBNPRV_CIDR" \
    --display-name "$VCN_FIREWALL_SUBNPRV_NAME" \
    --dns-label "$VCN_FIREWALL_SUBNPRV_DNS_NAME" \
    --dhcp-options-id "$vcn_firewall_dhcp_id" \
    --route-table-id "$vcn_firewall_subnprv_rt_id" \
    --security-list-ids "[\"$vcn_firewall_subnprv_secl_id\"]" \
    --prohibit-public-ip-on-vnic "true" \
    --wait-for-state AVAILABLE