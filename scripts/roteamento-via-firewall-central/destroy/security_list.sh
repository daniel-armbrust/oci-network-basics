#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/security_list.sh"

#---------------------------------#
# VCN-A / SUBNPRV - Security List #
#---------------------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_secl_id="$(get_secl_id "$VCN_A_SUBNPRV_SECL_NAME" "$vcn_a_id")"

oci network security-list delete \
    --security-list-id "$vcn_a_subnprv_secl_id" \
    --force \
    --wait-for-state "TERMINATED"

#---------------------------------#
# VCN-B / SUBNPRV - Security List #
#---------------------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_secl_id="$(get_secl_id "$VCN_B_SUBNPRV_SECL_NAME" "$vcn_b_id")"

oci network security-list delete \
    --security-list-id "$vcn_b_subnprv_secl_id" \
    --force \
    --wait-for-state "TERMINATED"

#----------------------------------------#
# VCN-FIREWALL / SUBNPRV - Security List #
#----------------------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_secl_id="$(get_secl_id "$VCN_FIREWALL_SUBNPRV_SECL_NAME" "$vcn_firewall_id")"

oci network security-list delete \
    --security-list-id "$vcn_firewall_subnprv_secl_id" \
    --force \
    --wait-for-state "TERMINATED"