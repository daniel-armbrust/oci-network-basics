#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_id" \
    --wait-for-state "TERMINATED" \
    --force