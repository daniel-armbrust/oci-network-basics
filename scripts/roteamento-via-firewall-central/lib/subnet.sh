#!/bin/bash

get_subnet_id() {
    local display_name="$1"
    local vcn_id="$2"
    local cidr_block="$3"

    oci network subnet list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --display-name "$display_name" \
        --vcn-id "$vcn_id" \
        --query "data[?\"display-name\"=='$display_name' && \"vcn-id\"=='$vcn_id' && \"cidr-block\"=='$cidr_block'].id | [0]" \
        --raw-output
}