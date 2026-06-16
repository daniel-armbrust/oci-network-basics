#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/security_list.sh"
source "../../lib/dhcp_options.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_dhcp_id="$(get_dhcp_id "$VCN_DHCP_NAME" "$vcn_id")"
vcn_subnprv_rt_id="$(get_route_table_id "$SUBNPRV_RT_NAME" "$vcn_id")"
vcn_subnprv_secl_id="$(get_secl_id "$SUBNPRV_SECL_NAME" "$vcn_id")"

oci network subnet create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_id" \
    --cidr-block "$SUBNPRV_CIDR" \
    --display-name "$SUBNPRV_NAME" \
    --dns-label "$SUBNPRV_DNS_NAME" \
    --dhcp-options-id "$vcn_dhcp_id" \
    --route-table-id "$vcn_subnprv_rt_id" \
    --security-list-ids "[\"$vcn_subnprv_secl_id\"]" \
    --prohibit-public-ip-on-vnic "false" \
    --wait-for-state AVAILABLE