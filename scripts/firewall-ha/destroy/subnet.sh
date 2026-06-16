#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_id="$(get_subnet_id "$SUBNPRV_NAME" "$vcn_id" "$SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"