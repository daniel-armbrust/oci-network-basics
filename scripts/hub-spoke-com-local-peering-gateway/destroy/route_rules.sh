#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_rt_id="$(get_route_table_id "$VCN_A_SUBNPRV_RT_NAME" "$vcn_a_id")"

oci network route-table update \
    --rt-id "$vcn_a_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'

#---------#
# VCN-HUB #
#---------#
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"
vcn_hub_subnprv_rt_id="$(get_route_table_id "$VCN_HUB_SUBNPRV_RT_NAME" "$vcn_hub_id")"
vcn_hub_rt_id="$(get_route_table_id "$VCN_HUB_RT_DRG_NAME" "$vcn_hub_id")"
vcn_hub_vcn_firewall_lpg_rt_id="$(get_route_table_id "$VCN_HUB_VCN_FIREWALL_LPG_RT_NAME" "$vcn_hub_id")"

oci network route-table update \
    --rt-id "$vcn_hub_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'

oci network route-table update \
    --rt-id "$vcn_hub_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'

oci network route-table update \
    --rt-id "$vcn_hub_vcn_firewall_lpg_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'

#--------------#
# VCN-FIREWALL #
#--------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_rt_id="$(get_route_table_id "$VCN_FIREWALL_SUBNPRV_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_vcn_hub_lpg_rt_id="$(get_route_table_id "$VCN_FIREWALL_VCN_HUB_LPG_RT_NAME" "$vcn_firewall_id")"

oci network route-table update \
    --rt-id "$vcn_firewall_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'

oci network route-table update \
    --rt-id "$vcn_firewall_vcn_hub_lpg_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"

oci network route-table update \
    --rt-id "$vcn_b_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[]'