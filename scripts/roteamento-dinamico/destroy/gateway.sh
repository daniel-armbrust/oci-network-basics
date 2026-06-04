#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_a_id")"
vcn_a_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_a_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_a_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

oci network internet-gateway delete \
    --ig-id "$vcn_a_igw_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_b_id")"
vcn_b_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_b_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_b_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

oci network internet-gateway delete \
    --ig-id "$vcn_b_igw_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"
vcn_c_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_c_id")"
vcn_c_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_c_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_c_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

oci network internet-gateway delete \
    --ig-id "$vcn_c_igw_id" \
    --wait-for-state "TERMINATED" \
    --force