#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/gateway.sh"

#----------------#
# VCN-A Gateways #
#----------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_a_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_a_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

#----------------#
# VCN-B Gateways #
#----------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_b_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_b_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

#-----------------------#
# VCN-FIREWALL Gateways #
#-----------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

vcn_firewall_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_firewall_id")"
vcn_firewall_ngw_id="$(get_ngw_id "$NGW_NAME" "$vcn_firewall_id")"

oci network service-gateway delete \
    --service-gateway-id "$vcn_firewall_sgw_id" \
    --wait-for-state "TERMINATED" \
    --force

oci network nat-gateway delete \
    --nat-gateway-id "$vcn_firewall_ngw_id" \
    --wait-for-state "TERMINATED" \
    --force