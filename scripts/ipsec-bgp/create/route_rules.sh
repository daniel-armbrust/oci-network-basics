#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/gateway.sh"
source "../../lib/compute.sh"
source "../../lib/subnet.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_a_id")"

# Public Subnet
vcn_a_subnpub_rt_id="$(get_route_table_id "$VCN_A_SUBNPUB_RT_NAME" "$vcn_a_id")"

oci network route-table update \
    --rt-id "$vcn_a_subnpub_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_a_igw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'