#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/drg.sh"

# DRG
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

#------------------# 
# DRG Route Table  #
#------------------#
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

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
rt_to_firewall_ip_id="$(get_route_table_id "$VCN_FRONTEND_TO_FIREWALL_IP_RT_NAME" "$vcn_frontend_id")"

oci network drg-attachment create \
    --display-name "$VCN_FRONTEND_DRGATTCH_NAME" \
    --drg-id "$drg_id" \
    --drg-route-table-id "$drg_rt_from_firewall_id" \
    --route-table-id "$rt_to_firewall_ip_id" \
    --vcn-id "$vcn_frontend_id" \
    --wait-for-state "ATTACHED"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

oci network drg-attachment create \
    --display-name "$VCN_BACKEND_DRGATTCH_NAME" \
    --drg-id "$drg_id" \
    --drg-route-table-id "$drg_rt_to_firewall_id" \
    --vcn-id "$vcn_backend_id" \
    --wait-for-state "ATTACHED"