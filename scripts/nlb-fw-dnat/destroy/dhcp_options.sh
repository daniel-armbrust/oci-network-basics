#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/dhcp_options.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_dhcp_id="$(get_dhcp_id "$VCN_FRONTEND_DHCP_NAME" "$vcn_frontend_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_frontend_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"\

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_dhcp_id="$(get_dhcp_id "$VCN_BACKEND_DHCP_NAME" "$vcn_backend_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_backend_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"