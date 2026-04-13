#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/subnet.sh"

#----------------#
# VCN-A / SUBNET #
#----------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_id="$(get_subnet_id "$VCN_A_SUBNPRV_NAME" "$vcn_a_id" "$VCN_A_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_a_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"

#----------------#
# VCN-B / SUBNET #
#----------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_id="$(get_subnet_id "$VCN_B_SUBNPRV_NAME" "$vcn_b_id" "$VCN_B_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_b_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"

#-----------------------#
# VCN-FIREWALL / SUBNET #
#-----------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_id="$(get_subnet_id "$VCN_FIREWALL_SUBNPRV_NAME" "$vcn_firewall_id" "$VCN_FIREWALL_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_firewall_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"