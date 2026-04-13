#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"

#---------------------------------#
# VCN-A / SUBNPRV - Security List #
#---------------------------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"

#---------------------------------#
# VCN-B / SUBNPRV - Security List #
#---------------------------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"

#----------------------------------------#
# VCN-FIREWALL / SUBNPRV - Security List #
#----------------------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"

oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_firewall_id" \
    --display-name "$VCN_FIREWALL_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"