#!/bin/bash

get_secl_id() {
    local display_name="$1"
    local vcn_id="$2"

    oci network security-list list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --display-name "$display_name" \
        --vcn-id "$vcn_id" \
        --query "data[?\"display-name\"=='$display_name'] | [0].id" \
        --raw-output
}