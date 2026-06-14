#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/drg.sh"

#-----#
# DRG #
#-----#

oci network drg create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$DRG_NAME" \
    --wait-for-state "AVAILABLE"

drg_id="$(get_drg_id "$DRG_NAME")"

#----------------# 
# DRG VCN Attach #
#----------------#

# DRG-1 / VCN-A
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network drg-attachment create \
    --display-name "$VCN_A_DRGATTCH_NAME" \
    --drg-id "$drg_id" \
    --vcn-id "$vcn_a_id" \
    --wait-for-state "ATTACHED"