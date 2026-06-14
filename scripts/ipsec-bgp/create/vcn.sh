#!/bin/bash

source "../data.env"

#-------#
# VCN-A #
#-------#
oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "$VCN_A_CIDR" \
    --display-name "$VCN_A_NAME" \
    --dns-label "$VCN_A_DNS_NAME" \
    --is-ipv6-enabled "false" \
    --wait-for-state "AVAILABLE"