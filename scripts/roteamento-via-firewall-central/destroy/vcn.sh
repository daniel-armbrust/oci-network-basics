#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_a_id" \
    --wait-for-state "TERMINATED" \
    --force

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_b_id" \
    --wait-for-state "TERMINATED" \
    --force

#--------------#
# VCN-FIREWALL #
#--------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

oci network vcn delete \
    --vcn-id "$vcn_firewall_id" \
    --wait-for-state "TERMINATED" \
    --force