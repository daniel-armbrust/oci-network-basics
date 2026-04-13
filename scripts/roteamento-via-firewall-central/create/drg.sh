#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/route_table.sh"
source "../lib/drg.sh"

oci network drg create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$DRG_NAME" \
    --wait-for-state "AVAILABLE"

drg_id="$(get_drg_id "$DRG_NAME")"

#----------------------------# 
# Import Route Distribution  #
#----------------------------#

# TO-FIREWALL
oci network drg-route-distribution create \
    --drg-id "$drg_id" \
    --distribution-type "IMPORT" \
    --display-name "$DRG_IMPRT_TO_FIREWALL_NAME" \
    --wait-for-state "AVAILABLE"

# FROM-FIREWALL
oci network drg-route-distribution create \
    --drg-id "$drg_id" \
    --distribution-type "IMPORT" \
    --display-name "$DRG_IMPRT_FROM_FIREWALL_NAME" \
    --wait-for-state "AVAILABLE"

# #------------------# 
# # DRG Route Table  #
# #------------------#
imprtdst_to_firewall_id="$(get_drg_imprtdst_id "$DRG_IMPRT_TO_FIREWALL_NAME" "$drg_id")"
imprtdst_from_firewall_id="$(get_drg_imprtdst_id "$DRG_IMPRT_FROM_FIREWALL_NAME" "$drg_id")"

# TO-FIREWALL
oci network drg-route-table create \
    --drg-id "$drg_id" \
    --display-name "$DRG_RT_TO_FIREWALL_NAME" \
    --import-route-distribution-id "$imprtdst_to_firewall_id" \
    --is-ecmp-enabled "false" \
    --wait-for-state "AVAILABLE"

# FROM-FIREWALL
oci network drg-route-table create \
    --drg-id "$drg_id" \
    --display-name "$DRG_RT_FROM_FIREWALL_NAME" \
    --import-route-distribution-id "$imprtdst_from_firewall_id" \
    --is-ecmp-enabled "false" \
    --wait-for-state "AVAILABLE"

# FROM-FIREWALL ** MATCH_ALL ** (A VCN do Firewall conhece TUDO!)
oci network drg-route-distribution-statement add \
    --route-distribution-id "$imprtdst_from_firewall_id" \
    --statements '[{
         "action": "ACCEPT",
         "priority": 1,
         "matchCriteria": []
    }]'

# DRG Route Table IDs
drg_rt_to_firewall_id="$(get_drg_rt_id "$DRG_RT_TO_FIREWALL_NAME" "$drg_id" "$imprtdst_to_firewall_id")"
drg_rt_from_firewall_id="$(get_drg_rt_id "$DRG_RT_FROM_FIREWALL_NAME" "$drg_id" "$imprtdst_from_firewall_id")"

#---------------------# 
# DRG Attach - VCN-A  #
#---------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network drg-attachment create \
    --display-name "$VCN_A_DRGATTCH_NAME" \
    --drg-id "$drg_id" \
    --drg-route-table-id "$drg_rt_to_firewall_id" \
    --vcn-id "$vcn_a_id" \
    --wait-for-state "ATTACHED"

#---------------------# 
# DRG Attach - VCN-B  #
#---------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network drg-attachment create \
    --display-name "$VCN_B_DRGATTCH_NAME" \
    --drg-id "$drg_id" \
    --drg-route-table-id "$drg_rt_to_firewall_id" \
    --vcn-id "$vcn_b_id" \
    --wait-for-state "ATTACHED"

#----------------------------# 
# DRG Attach - VCN-FIREWALL  #
#----------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
rt_to_firewall_ip_id="$(get_route_table_id "$VCN_FIREWALL_TO_FIREWALL_IP_RT_NAME" "$vcn_firewall_id")"

oci network drg-attachment create \
    --display-name "$VCN_FIREWALL_DRGATTCH_NAME" \
    --drg-id "$drg_id" \
    --drg-route-table-id "$drg_rt_from_firewall_id" \
    --route-table-id "$rt_to_firewall_ip_id" \
    --vcn-id "$vcn_firewall_id" \
    --wait-for-state "ATTACHED"