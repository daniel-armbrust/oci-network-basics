#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/security_list.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_secl_id="$(get_secl_id "$SUBNPRV_SECL_NAME" "$vcn_id")"

oci network security-list delete \
    --security-list-id "$vcn_subnprv_secl_id" \
    --force \
    --wait-for-state "TERMINATED"