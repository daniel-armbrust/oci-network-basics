#!/bin/bash

source "../data.env"
source "../../lib/drg.sh"
source "../../lib/vpn.sh"

drg_id="$(get_drg_id "$DRG_NAME")"
ipsec_id="$(get_ipsec_id "$VPN_NAME" "$drg_id")"

oci network ip-sec-connection delete \
    --ipsc-id "$ipsec_id" \
    --force \
    --wait-for-state "TERMINATED"

cpe_id="$(get_cpe_id "$CPE_NAME")" 

oci network cpe delete \
    --cpe-id "$cpe_id" \
    --force