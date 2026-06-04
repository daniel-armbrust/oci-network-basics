#!/bin/bash

get_dynagrp_id() {
    local name="$1"

    oci iam dynamic-group list \
        --all \
        --compartment-id "$TENANCY_ID" \
        --query "data[?name=='$name'].id | [0]" \
        --raw-output
}

get_iampolicy_id() {
    local name="$1"

    oci iam policy list \
        --compartment-id "$TENANCY_ID" \
        --all \
        --query "data[?name=='$name'].id | [0]" \
        --raw-output
}