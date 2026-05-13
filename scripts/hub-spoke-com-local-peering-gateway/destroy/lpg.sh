#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/lpg.sh"

#---------#
# VCN-HUB #
#---------#
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"
vcn_hub_vcn_firewall_lpg_id="$(get_lpg_id "$VCN_HUB_VCN_FIREWALL_LPG_NAME" "$vcn_hub_id")"
vcn_hub_vcn_firewall_lpg_rt_id="$(get_route_table_id "$VCN_HUB_VCN_FIREWALL_LPG_RT_NAME" "$vcn_hub_id")"

oci network local-peering-gateway delete \
    --local-peering-gateway-id "$vcn_hub_vcn_firewall_lpg_id" \
    --force \
    --wait-for-state "TERMINATED"

oci network route-table delete \
    --rt-id "$vcn_hub_vcn_firewall_lpg_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#--------------#
# VCN-FIREWALL #
#--------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_vcn_hub_lpg_rt_id="$(get_route_table_id "$VCN_FIREWALL_VCN_HUB_LPG_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_vcn_hub_lpg_id="$(get_lpg_id "$VCN_FIREWALL_VCN_HUB_LPG_NAME" "$vcn_firewall_id")"

oci network local-peering-gateway delete \
    --local-peering-gateway-id "$vcn_firewall_vcn_hub_lpg_id" \
    --force

oci network route-table delete \
    --rt-id "$vcn_firewall_vcn_hub_lpg_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

vcn_firewall_vcn_b_lpg_id="$(get_lpg_id "$VCN_FIREWALL_VCN_B_LPG_NAME" "$vcn_firewall_id")"
vcn_firewall_vcn_b_lpg_rt_id="$(get_route_table_id "$VCN_FIREWALL_VCN_B_LPG_RT_NAME" "$vcn_firewall_id")"

oci network local-peering-gateway delete \
    --local-peering-gateway-id "$vcn_firewall_vcn_b_lpg_id" \
    --force

oci network route-table delete \
    --rt-id "$vcn_firewall_vcn_b_lpg_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_vcn_firewall_lpg_rt_id="$(get_route_table_id "$VCN_B_VCN_FIREWALL_LPG_RT_NAME" "$vcn_b_id")"
vcn_b_vcn_firewall_lpg_id="$(get_lpg_id "$VCN_B_VCN_FIREWALL_LPG_NAME" "$vcn_b_id")"

oci network local-peering-gateway delete \
    --local-peering-gateway-id "$vcn_b_vcn_firewall_lpg_id" \
    --force

oci network route-table delete \
    --rt-id "$vcn_b_vcn_firewall_lpg_rt_id" \
    --force \
    --wait-for-state "TERMINATED"