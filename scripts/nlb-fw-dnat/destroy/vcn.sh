#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_frontend_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_backend_id" \
    --wait-for-state "TERMINATED" \
    --force