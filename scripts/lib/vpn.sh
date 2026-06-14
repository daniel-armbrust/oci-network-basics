#!/bin/bash

get_cpe_id() {
    local display_name="$1" 

    oci network cpe list \
        --compartment-id "$COMPARTMENT_ID" \
        --query "data[?\"display-name\"=='$display_name'].id | [0]" \
        --raw-output
}

get_ipsec_id() {
    local display_name="$1"
    local drg_id="$2"

    oci network ip-sec-connection list \
        --compartment-id "$COMPARTMENT_ID" \
        --drg-id "$drg_id" \
        --all \
        --query "data[?\"display-name\"=='$display_name'].id | [0]" \
        --raw-output
}

get_ipsec_tunnel_1_id() {
    local ipsec_id="$1"
  
    oci network ip-sec-tunnel list \
        --ipsc-id "$ipsec_id" \
        --all \
        --query 'data[0].id' \
        --raw-output
}

get_ipsec_tunnel_2_id() {
    local ipsec_id="$1"

    oci network ip-sec-tunnel list \
        --ipsc-id "$ipsec_id" \
        --all \
        --query 'data[1].id' \
        --raw-output
}

get_ipsec_tunnel_ip() {
    local ipsec_id="$1"
    local tunnel_id="$2"

   oci network ip-sec-tunnel get \
        --ipsc-id $ipsec_id \
        --tunnel-id "$tunnel_id" \
        --query 'data."vpn-ip"' \
        --raw-output
}

get_ipsec_tunnel_psk() {
    local ipsec_id="$1"
    local tunnel_id="$2"

    oci network ip-sec-psk get \
        --ipsc-id "$ipsec_id" \
        --tunnel-id "$tunnel_id" \
        --query 'data."shared-secret"' \
        --raw-output
}