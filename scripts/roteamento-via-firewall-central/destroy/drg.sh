#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/drg.sh"

drg_id="$(get_drg_id "$DRG_NAME")"

#---------------------# 
# DRG Attach - VCN-A  #
#---------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_drg_attch_id="$(get_drg_attch_id "$VCN_A_DRGATTCH_NAME" "$drg_id" "$vcn_a_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_a_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#---------------------# 
# DRG Attach - VCN-B  #
#---------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_drg_attch_id="$(get_drg_attch_id "$VCN_B_DRGATTCH_NAME" "$drg_id" "$vcn_b_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_b_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#----------------------------# 
# DRG Attach - VCN-FIREWALL  #
#----------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_drg_attch_id="$(get_drg_attch_id "$VCN_FIREWALL_DRGATTCH_NAME" "$drg_id" "$vcn_firewall_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_firewall_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#-----# 
# DRG #
#-----#
oci network drg delete \
    --drg-id "$drg_id" \
    --force \
    --wait-for-state "TERMINATED"