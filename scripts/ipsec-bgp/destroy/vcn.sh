#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_a_id" \
    --wait-for-state "TERMINATED" \
    --force