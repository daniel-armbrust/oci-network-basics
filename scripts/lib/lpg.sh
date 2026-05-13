#!/bin/bash

get_lpg_id() {
    local display_name="$1"
    local vcn_id="$2"

    oci network local-peering-gateway list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --vcn-id "$vcn_id" \
        --query "data[?\"display-name\"=='$display_name' && \"vcn-id\"=='$vcn_id'].id | [0]" \
        --raw-output
}