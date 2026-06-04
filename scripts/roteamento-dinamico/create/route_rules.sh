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
vcn_a_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_a_id")"
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

# Private Subnet
vcn_a_subnprv_rt_id="$(get_route_table_id "$VCN_A_SUBNPRV_RT_NAME" "$vcn_a_id")"

oci network route-table update \
    --rt-id "$vcn_a_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_a_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_b_id")"
vcn_b_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_b_id")"

# Public Subnet
vcn_b_subnpub_rt_id="$(get_route_table_id "$VCN_B_SUBNPUB_RT_NAME" "$vcn_b_id")"

oci network route-table update \
    --rt-id "$vcn_b_subnpub_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_b_igw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

# Private Subnet
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"

oci network route-table update \
    --rt-id "$vcn_b_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_b_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"
vcn_c_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_c_id")"
vcn_c_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_c_id")"

# Public Subnet
vcn_c_subnpub_rt_id="$(get_route_table_id "$VCN_C_SUBNPUB_RT_NAME" "$vcn_c_id")"

oci network route-table update \
    --rt-id "$vcn_c_subnpub_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_c_igw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

# Private Subnet
vcn_c_subnprv_rt_id="$(get_route_table_id "$VCN_C_SUBNPRV_RT_NAME" "$vcn_c_id")"

oci network route-table update \
    --rt-id "$vcn_c_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_c_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'
