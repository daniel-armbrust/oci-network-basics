#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_frontend_id")"

oci network internet-gateway delete \
    --ig-id "$vcn_frontend_igw_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_backend_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_backend_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force