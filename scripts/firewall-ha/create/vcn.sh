#!/bin/bash

source "../data.env"

oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "$VCN_CIDR" \
    --display-name "$VCN_NAME" \
    --dns-label "$VCN_DNS_NAME" \
    --is-ipv6-enabled "false" \
    --wait-for-state "AVAILABLE"