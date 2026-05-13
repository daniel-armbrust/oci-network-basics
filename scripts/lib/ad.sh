#!/bin/bash

get_availability_domain() {
    oci iam availability-domain list \
        --compartment-id "$COMPARTMENT_ID" \
        --query "data[0].name" \
        --raw-output
}