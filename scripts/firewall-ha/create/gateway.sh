#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

sgw_all_services_id="$(get_sgw_all_services_id)"
vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"

oci network service-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_id" \
    --display-name "$SGW_NAME" \
    --services '[{"serviceId":"'"$sgw_all_services_id"'"}]' \
    --wait-for-state "AVAILABLE"

oci network nat-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_id" \
    --block-traffic "false" \
    --display-name "$NGW_NAME" \
    --wait-for-state "AVAILABLE"