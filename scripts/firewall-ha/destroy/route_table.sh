#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_rt_id="$(get_route_table_id "$SUBNPRV_RT_NAME" "$vcn_id")"

oci network route-table delete \
    --rt-id "$vcn_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"