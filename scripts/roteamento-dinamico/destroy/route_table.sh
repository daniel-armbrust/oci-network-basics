#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# Public Subnet
vcn_a_subnpub_rt_id="$(get_route_table_id "$VCN_A_SUBNPUB_RT_NAME" "$vcn_a_id")"

oci network route-table delete \
    --rt-id "$vcn_a_subnpub_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

# Private Subnet
vcn_a_subnprv_rt_id="$(get_route_table_id "$VCN_A_SUBNPRV_RT_NAME" "$vcn_a_id")"

oci network route-table delete \
    --rt-id "$vcn_a_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

# Public Subnet
vcn_b_subnpub_rt_id="$(get_route_table_id "$VCN_B_SUBNPUB_RT_NAME" "$vcn_b_id")"

oci network route-table delete \
    --rt-id "$vcn_b_subnpub_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

# Private Subnet
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"

oci network route-table delete \
    --rt-id "$vcn_b_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

# Public Subnet
vcn_c_subnpub_rt_id="$(get_route_table_id "$VCN_C_SUBNPUB_RT_NAME" "$vcn_c_id")"

oci network route-table delete \
    --rt-id "$vcn_c_subnpub_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

# Private Subnet
vcn_c_subnprv_rt_id="$(get_route_table_id "$VCN_C_SUBNPRV_RT_NAME" "$vcn_c_id")"

oci network route-table delete \
    --rt-id "$vcn_c_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

