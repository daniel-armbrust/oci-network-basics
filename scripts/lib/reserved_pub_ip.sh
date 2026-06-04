#!/bin/bash

get_reserved_pub_ip() {
    local display_name="$1"

    oci network public-ip list \
        --compartment-id "$COMPARTMENT_ID" \
        --scope "REGION" \
        --all \
        --lifetime "RESERVED" \
        --query "data[?\"display-name\"=='$display_name'].\"ip-address\" | [0]" \
        --raw-output
}

get_reserved_pub_ip_id() {
    local pub_ip="$1"

    oci network public-ip list \
        --compartment-id "$COMPARTMENT_ID" \
        --scope "REGION" \
        --all \
        --lifetime "RESERVED" \
        --query "data[?\"ip-address\"=='$pub_ip'].id | [0]" \
        --raw-output
}