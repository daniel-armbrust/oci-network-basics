#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/gateway.sh"
source "../../lib/compute.sh"
source "../../lib/subnet.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_rt_id="$(get_route_table_id "$SUBNPRV_RT_NAME" "$vcn_id")"
vcn_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_id")"
vcn_ngw_id="$(get_ngw_id "$NGW_NAME" "$vcn_id")"

oci network route-table update \
    --rt-id "$vcn_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_ngw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination":  "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$vcn_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'