#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# Public Subnet
vcn_a_subnpub_id="$(get_subnet_id "$VCN_A_SUBNPUB_NAME" "$vcn_a_id" "$VCN_A_SUBNPUB_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_a_subnpub_id" \
    --force \
    --wait-for-state "TERMINATED"

# Private Subnet
vcn_a_subnprv_id="$(get_subnet_id "$VCN_A_SUBNPRV_NAME" "$vcn_a_id" "$VCN_A_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_a_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

# Public Subnet
vcn_b_subnpub_id="$(get_subnet_id "$VCN_B_SUBNPUB_NAME" "$vcn_b_id" "$VCN_B_SUBNPUB_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_b_subnpub_id" \
    --force \
    --wait-for-state "TERMINATED"

# Private Subnet
vcn_b_subnprv_id="$(get_subnet_id "$VCN_B_SUBNPRV_NAME" "$vcn_b_id" "$VCN_B_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_b_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

# Public Subnet
vcn_c_subnpub_id="$(get_subnet_id "$VCN_C_SUBNPUB_NAME" "$vcn_c_id" "$VCN_C_SUBNPUB_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_c_subnpub_id" \
    --force \
    --wait-for-state "TERMINATED"

# Private Subnet
vcn_c_subnprv_id="$(get_subnet_id "$VCN_C_SUBNPRV_NAME" "$vcn_c_id" "$VCN_C_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_c_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"