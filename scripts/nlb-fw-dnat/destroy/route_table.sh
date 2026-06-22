#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

# Sub-rede Pública
vcn_frontend_subnpub_rt_id="$(get_route_table_id "$VCN_FRONTEND_SUBNPUB_RT_NAME" "$vcn_frontend_id")"

oci network route-table delete \
    --rt-id "$vcn_frontend_subnpub_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

# TO-FIREWALL-IP
vcn_frontend_to_firewall_ip_rt_id="$(get_route_table_id "$VCN_FRONTEND_TO_FIREWALL_IP_RT_NAME" "$vcn_frontend_id")"

oci network route-table delete \
    --rt-id "$vcn_frontend_to_firewall_ip_rt_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

# Sub-rede Privada
vcn_backend_subnprv_rt_id="$(get_route_table_id "$VCN_BACKEND_SUBNPRV_RT_NAME" "$vcn_backend_id")"

oci network route-table delete \
    --rt-id "$vcn_backend_subnprv_rt_id" \
    --force \
    --wait-for-state "TERMINATED"