#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/gateway.sh"

# Service Gateway - ALL SERVICES
sgw_all_services_id="$(get_sgw_all_services_id)"

#----------------#
# VCN-A Gateways #
#----------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network service-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$SGW_NAME" \
    --services '[{"serviceId":"'"$sgw_all_services_id"'"}]' \
    --wait-for-state "AVAILABLE"

#----------------#
# VCN-B Gateways #
#----------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network service-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$SGW_NAME" \
    --services '[{"serviceId":"'"$sgw_all_services_id"'"}]' \
    --wait-for-state "AVAILABLE"

#-----------------------#
# VCN-FIREWALL Gateways #
#-----------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

oci network service-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$SGW_NAME" \
    --services '[{"serviceId":"'"$sgw_all_services_id"'"}]' \
    --wait-for-state "AVAILABLE"

oci network nat-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --block-traffic "false" \
    --display-name "$NGW_NAME" \
    --wait-for-state "AVAILABLE"