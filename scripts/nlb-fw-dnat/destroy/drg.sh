#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/drg.sh"

# DRG
drg_id="$(get_drg_id "$DRG_NAME")"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_drg_attch_id="$(get_drg_attch_id "$VCN_FRONTEND_DRGATTCH_NAME" "$drg_id" "$vcn_frontend_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_frontend_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_drg_attch_id="$(get_drg_attch_id "$VCN_BACKEND_DRGATTCH_NAME" "$drg_id" "$vcn_backend_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_backend_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#-----# 
# DRG #
#-----#
oci network drg delete \
    --drg-id "$drg_id" \
    --force \
    --wait-for-state "TERMINATED"