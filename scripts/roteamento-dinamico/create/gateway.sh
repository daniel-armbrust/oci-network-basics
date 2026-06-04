#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/gateway.sh"

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

oci network internet-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$IGW_NAME" \
    --is-enabled true \
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

oci network internet-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$IGW_NAME" \
    --is-enabled true \
    --wait-for-state "AVAILABLE"

#----------------#
# VCN-C Gateways #
#----------------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

oci network service-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_c_id" \
    --display-name "$SGW_NAME" \
    --services '[{"serviceId":"'"$sgw_all_services_id"'"}]' \
    --wait-for-state "AVAILABLE"

oci network internet-gateway create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_c_id" \
    --display-name "$IGW_NAME" \
    --is-enabled true \
    --wait-for-state "AVAILABLE"