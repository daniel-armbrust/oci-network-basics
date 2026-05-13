#!/bin/bash

source "../network.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/lpg.sh"

#---------#
# VCN-HUB #
#---------#
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"

# Route Table / VCN_HUB VCN_FIREWALL
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_hub_id" \
    --display-name "$VCN_HUB_VCN_FIREWALL_LPG_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# LPG
vcn_hub_vcn_firewall_lpg_rt_id="$(get_route_table_id "$VCN_HUB_VCN_FIREWALL_LPG_RT_NAME" "$vcn_hub_id")"

oci network local-peering-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_hub_id" \
    --display-name "$VCN_HUB_VCN_FIREWALL_LPG_NAME" \
    --route-table-id "$vcn_hub_vcn_firewall_lpg_rt_id" \
    --wait-for-state "AVAILABLE"

#--------------#
# VCN-FIREWALL #
#--------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

# Route Table / VCN_FIREWALL VCN_HUB
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_VCN_HUB_LPG_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# Route Table / VCN_FIREWALL VCN_B
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_VCN_B_LPG_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# LPG
vcn_firewall_vcn_hub_lpg_rt_id="$(get_route_table_id "$VCN_FIREWALL_VCN_HUB_LPG_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_vcn_b_lpg_rt_id="$(get_route_table_id "$VCN_FIREWALL_VCN_B_LPG_RT_NAME" "$vcn_firewall_id")"

oci network local-peering-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_VCN_HUB_LPG_NAME" \
    --route-table-id "$vcn_firewall_vcn_hub_lpg_rt_id" \
    --wait-for-state "AVAILABLE"

oci network local-peering-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_VCN_B_LPG_NAME" \
    --route-table-id "$vcn_firewall_vcn_b_lpg_rt_id" \
    --wait-for-state "AVAILABLE"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

# Route Table / VCN_HUB VCN_FIREWALL
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_VCN_FIREWALL_LPG_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# LPG
vcn_b_vcn_firewall_lpg_rt_id="$(get_route_table_id "$VCN_B_VCN_FIREWALL_LPG_RT_NAME" "$vcn_b_id")"

oci network local-peering-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_VCN_FIREWALL_LPG_NAME" \
    --route-table-id "$vcn_b_vcn_firewall_lpg_rt_id" \
    --wait-for-state "AVAILABLE"

#------------------------#
# VCN_HUB / VCN-FIREWALL #
#------------------------#
vcn_hub_vcn_firewall_lpg_id="$(get_lpg_id "$VCN_HUB_VCN_FIREWALL_LPG_NAME" "$vcn_hub_id")"
vcn_firewall_vcn_hub_lpg_id="$(get_lpg_id "$VCN_FIREWALL_VCN_HUB_LPG_NAME" "$vcn_firewall_id")"

oci network local-peering-gateway connect \
    --local-peering-gateway-id "$vcn_hub_vcn_firewall_lpg_id" \
    --peer-id "$vcn_firewall_vcn_hub_lpg_id"

#----------------------#
# VCN_FIREWALL / VCN-B #
#----------------------#
vcn_firewall_vcn_b_lpg_id="$(get_lpg_id "$VCN_FIREWALL_VCN_B_LPG_NAME" "$vcn_firewall_id")"
vcn_b_vcn_firewall_lpg_id="$(get_lpg_id "$VCN_B_VCN_FIREWALL_LPG_NAME" "$vcn_b_id")"

oci network local-peering-gateway connect \
    --local-peering-gateway-id "$vcn_firewall_vcn_b_lpg_id" \
    --peer-id "$vcn_b_vcn_firewall_lpg_id"