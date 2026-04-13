#!/bin/bash

get_drg_id() {
    local display_name="$1"
   
    oci network drg list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --query "data[?\"display-name\"=='$display_name'] | [0].id" \
        --raw-output
}

get_drg_imprtdst_id() {
    local display_name="$1"
    local drg_id="$2"

    oci network drg-route-distribution list \
        --all \
        --drg-id "$drg_id" \
        --lifecycle-state "AVAILABLE" \
        --query "data[?\"display-name\"=='$display_name'] | [0].id" \
        --raw-output
}

get_drg_rt_id() {
    local display_name="$1"
    local drg_id="$2"
    local drg_imprt_id="$3"

    oci network drg-route-table list \
        --display-name "$display_name" \
        --all \
        --drg-id "$drg_id" \
        --import-route-distribution-id "$drg_imprt_id" \
        --lifecycle-state "AVAILABLE" \
        --query "data[?\"display-name\"=='$display_name'] | [0].id" \
        --raw-output
}

get_drg_attch_id() {
    local display_name="$1"
    local drg_id="$2"
    local vcn_id="$3"

    oci network drg-attachment list \
        --compartment-id "$COMPARTMENT_ID" \
        --display-name "$display_name" \
        --all \
        --attachment-type "VCN" \
        --drg-id "$drg_id" \
        --lifecycle-state "ATTACHED" \
        --vcn-id "$vcn_id" \
        --query "data[?\"display-name\"=='$display_name'] | [0].id" \
        --raw-output    
}