#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

sgw_all_services_id="$(get_sgw_all_services_id)"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

oci network internet-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_frontend_id" \
    --display-name "$IGW_NAME" \
    --is-enabled true \
    --wait-for-state "AVAILABLE"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

oci network service-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_backend_id" \
    --display-name "$SGW_NAME" \
    --services '[{"serviceId":"'"$sgw_all_services_id"'"}]' \
    --wait-for-state "AVAILABLE"