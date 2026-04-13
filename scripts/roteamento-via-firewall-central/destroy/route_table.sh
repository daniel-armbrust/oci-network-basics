#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/route_table.sh"

#-------------------------------#
# VCN-A / SUBNPRV - Route Table #
#-------------------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_rt_id="$(get_route_table_id "$VCN_A_SUBNPRV_RT_NAME" "$vcn_a_id")"

oci network route-table delete \
    --rt-id "$vcn_a_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------------------------------#
# VCN-B / SUBNPRV - Route Table #
#-------------------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"

oci network route-table delete \
    --rt-id "$vcn_b_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#--------------------------------------#
# VCN-FIREWALL / SUBNPRV - Route Table #
#--------------------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_rt_id="$(get_route_table_id "$VCN_FIREWALL_SUBNPRV_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_to_firewall_ip_rt_id="$(get_route_table_id "$VCN_FIREWALL_TO_FIREWALL_IP_RT_NAME" "$vcn_firewall_id")"

oci network route-table delete \
    --rt-id "$vcn_firewall_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

# TO-FIREWALL-IP
oci network route-table delete \
    --rt-id "$vcn_firewall_to_firewall_ip_rt_id" \
    --force \
    --wait-for-state "TERMINATED"