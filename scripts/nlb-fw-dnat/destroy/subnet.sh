#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

# Sub-rede Pública
vcn_frontend_subnpub_id="$(get_subnet_id "$VCN_FRONTEND_SUBNPUB_NAME" "$vcn_frontend_id" "$VCN_FRONTEND_SUBNPUB_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_frontend_subnpub_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

# Sub-rede Privada
vcn_backend_subnprv_id="$(get_subnet_id "$VCN_BACKEND_SUBNPRV_NAME" "$vcn_backend_id" "$VCN_BACKEND_SUBNPRV_CIDR")"

oci network subnet delete \
    --subnet-id "$vcn_backend_subnprv_id" \
    --force \
    --wait-for-state "TERMINATED"
