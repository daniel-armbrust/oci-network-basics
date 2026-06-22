#!/bin/bash

source "../data.env"

#--------------#
# VCN-FRONTEND #
#--------------#
oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "$VCN_FRONTEND_CIDR" \
    --display-name "$VCN_FRONTEND_NAME" \
    --dns-label "$VCN_FRONTEND_DNS_NAME" \
    --is-ipv6-enabled "false" \
    --wait-for-state "AVAILABLE"

#-------------#
# VCN-BACKEND #
#-------------#
oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "$VCN_BACKEND_CIDR" \
    --display-name "$VCN_BACKEND_NAME" \
    --dns-label "$VCN_BACKEND_DNS_NAME" \
    --is-ipv6-enabled "false" \
    --wait-for-state "AVAILABLE"