#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/security_list.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# Public Subnet
vcn_a_subnpub_secl_id="$(get_secl_id "$VCN_A_SUBNPUB_SECL_NAME" "$vcn_a_id")"

oci network security-list delete \
    --security-list-id "$vcn_a_subnpub_secl_id" \
    --force \
    --wait-for-state "TERMINATED"