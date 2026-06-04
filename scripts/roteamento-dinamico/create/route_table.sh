#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# VCN-A / SUBNPUB - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPUB_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# VCN-A / SUBNPRV - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

# VCN-B / SUBNPUB - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_SUBNPUB_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# VCN-B / SUBNPRV - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

# VCN-C / SUBNPUB - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_c_id" \
    --display-name "$VCN_C_SUBNPUB_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# VCN-C / SUBNPRV - Route Table
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_c_id" \
    --display-name "$VCN_C_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"