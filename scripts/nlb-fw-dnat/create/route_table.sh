#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

# Sub-rede Pública
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_frontend_id" \
    --display-name "$VCN_FRONTEND_SUBNPUB_RT_NAME" \
     --route-rules '[]' \
    --wait-for-state "AVAILABLE"

# TO-FIREWALL-IP
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_frontend_id" \
    --display-name "$VCN_FRONTEND_TO_FIREWALL_IP_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

# Sub-rede Privada
oci network route-table create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_backend_id" \
    --display-name "$VCN_BACKEND_SUBNPRV_RT_NAME" \
    --route-rules '[]' \
    --wait-for-state "AVAILABLE"