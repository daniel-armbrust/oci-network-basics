#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/drg.sh"

drg_id="$(get_drg_id "$DRG_NAME")"

#----------------# 
# DRG VCN Attach #
#----------------#

# DRG-1 / VCN
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_drg_attch_id="$(get_drg_attch_id "$VCN_A_DRGATTCH_NAME" "$drg_id" "$vcn_a_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_a_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#-----#
# DRG #
#-----#

# DRG-1
oci network drg delete \
    --drg-id "$drg_id" \
    --force \
    --wait-for-state "TERMINATED"