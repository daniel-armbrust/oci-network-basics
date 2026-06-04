#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_a_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_b_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_c_id" \
    --wait-for-state "TERMINATED" \
    --force