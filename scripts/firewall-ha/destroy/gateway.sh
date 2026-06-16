#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_id")"
vcn_ngw_id="$(get_ngw_id "$NGW_NAME" "$vcn_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

oci network nat-gateway delete \
    --nat-gateway-id "$vcn_ngw_id" \
    --wait-for-state "TERMINATED" \
    --force