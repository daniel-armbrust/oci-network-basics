#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/dhcp_options.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_dhcp_id="$(get_dhcp_id "$VCN_DHCP_NAME" "$vcn_id")"

oci network dhcp-options delete \
    --dhcp-id "$vcn_dhcp_id" \
    --force \
    --wait-for-state "TERMINATED"