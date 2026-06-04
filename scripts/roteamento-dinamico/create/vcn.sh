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

#-------#
# VCN-B #
#-------#
oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "$VCN_B_CIDR" \
    --display-name "$VCN_B_NAME" \
    --dns-label "$VCN_B_DNS_NAME" \
    --is-ipv6-enabled "false" \
    --wait-for-state "AVAILABLE"

#-------#
# VCN-C #
#-------#
oci network vcn create \
    --compartment-id "$COMPARTMENT_ID" \
    --cidr-block "$VCN_C_CIDR" \
    --display-name "$VCN_C_NAME" \
    --dns-label "$VCN_C_DNS_NAME" \
    --is-ipv6-enabled "false" \
    --wait-for-state "AVAILABLE"