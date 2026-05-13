#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#-------------------------------#
# VCN-A / SUBNPRV - Route Table #
#-------------------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

#---------------------------------#
# VCN-HUB / SUBNPRV - Route Table #
#---------------------------------#
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"

oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_hub_id" \
    --display-name "$VCN_HUB_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# TO-FIREWALL-LPG
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_hub_id" \
    --display-name "$VCN_HUB_RT_DRG_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

#--------------------------------------#
# VCN-FIREWALL / SUBNPRV - Route Table #
#--------------------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

#-------------------------------#
# VCN-B / SUBNPRV - Route Table #
#-------------------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"