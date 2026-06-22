#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/security_list.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"

# Sub-rede Pública
vcn_frontend_subnpub_secl_id="$(get_secl_id "$VCN_FRONTEND_SUBNPUB_SECL_NAME" "$vcn_frontend_id")"

oci network security-list delete \
    --security-list-id "$vcn_frontend_subnpub_secl_id" \
    --force \
    --wait-for-state "TERMINATED"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

# Sub-rede Privada
vcn_backend_subnprv_secl_id="$(get_secl_id "$VCN_BACKEND_SUBNPRV_SECL_NAME" "$vcn_backend_id")"

oci network security-list delete \
    --security-list-id "$vcn_backend_subnprv_secl_id" \
    --force \
    --wait-for-state "TERMINATED"