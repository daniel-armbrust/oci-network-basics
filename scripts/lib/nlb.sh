#!/bin/bash

get_nlb_id() {
    local display_name="$1"

    oci nlb network-load-balancer list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --display-name "$display_name" \
        --query 'data.items[0].id' \
        --raw-output
}