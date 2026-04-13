#!/bin/bash

get_dhcp_id() {
    local display_name="$1"
    local vcn_id="$2"

    oci network dhcp-options list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --display-name "$display_name" \
        --vcn-id "$vcn_id" \
        --query "data[?\"display-name\"=='$display_name' && \"vcn-id\"=='$vcn_id'].id | [0]" \
        --raw-output
}