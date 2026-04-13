#!/bin/bash

get_sgw_all_services_id() {
    oci network service list --all \
        --query "data[?contains(name, 'Oracle Services Network')].id | [0]" \
        --raw-output
}

get_sgw_id() {
    local display_name="$1"
    local vcn_id="$2"

    oci network service-gateway list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --query "data[?\"display-name\"=='$display_name' && \"vcn-id\"=='$vcn_id'].id | [0]" \
        --raw-output
}

get_ngw_id() {
    local display_name="$1"
    local vcn_id="$2"

    oci network nat-gateway list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --display-name "$display_name" \
        --vcn-id "$vcn_id" \
        --query "data[?\"display-name\"=='$display_name' && \"vcn-id\"=='$vcn_id'].id | [0]" \
        --raw-output
}