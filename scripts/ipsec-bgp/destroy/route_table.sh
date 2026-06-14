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