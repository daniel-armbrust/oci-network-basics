#!/bin/bash

get_vcn_id() {
    local display_name="$1"
    local cidr_block="$2"

    oci network vcn list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --query "data[?\"display-name\"=='$display_name' && \"cidr-block\"=='$cidr_block'].id | [0]" \
        --raw-output
}