#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/security_list.sh"
source "../../lib/dhcp_options.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_dhcp_id="$(get_dhcp_id "$VCN_FRONTEND_DHCP_NAME" "$vcn_frontend_id")"

# Sub-rede Pública
vcn_frontend_subnpub_rt_id="$(get_route_table_id "$VCN_FRONTEND_SUBNPUB_RT_NAME" "$vcn_frontend_id")"
vcn_frontend_subnpub_secl_id="$(get_secl_id "$VCN_FRONTEND_SUBNPUB_SECL_NAME" "$vcn_frontend_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_frontend_id" \
    --cidr-block "$VCN_FRONTEND_SUBNPUB_CIDR" \
    --display-name "$VCN_FRONTEND_SUBNPUB_NAME" \
    --dns-label "$VCN_FRONTEND_SUBNPUB_DNS_NAME" \
    --dhcp-options-id "$vcn_frontend_dhcp_id" \
    --route-table-id "$vcn_frontend_subnpub_rt_id" \
    --security-list-ids "[\"$vcn_frontend_subnpub_secl_id\"]" \
    --prohibit-public-ip-on-vnic "false" \
    --wait-for-state AVAILABLE

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_dhcp_id="$(get_dhcp_id "$VCN_BACKEND_DHCP_NAME" "$vcn_backend_id")"

# Sub-rede Privada
vcn_backend_subnprv_rt_id="$(get_route_table_id "$VCN_BACKEND_SUBNPRV_RT_NAME" "$vcn_backend_id")"
vcn_backend_subnprv_secl_id="$(get_secl_id "$VCN_BACKEND_SUBNPRV_SECL_NAME" "$vcn_backend_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_backend_id" \
    --cidr-block "$VCN_BACKEND_SUBNPRV_CIDR" \
    --display-name "$VCN_BACKEND_SUBNPRV_NAME" \
    --dns-label "$VCN_BACKEND_SUBNPRV_DNS_NAME" \
    --dhcp-options-id "$vcn_backend_dhcp_id" \
    --route-table-id "$vcn_backend_subnprv_rt_id" \
    --security-list-ids "[\"$vcn_backend_subnprv_secl_id\"]" \
    --prohibit-public-ip-on-vnic "true" \
    --wait-for-state AVAILABLE