#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"

#--------#
# VM-A-1 #
#--------#
oci network public-ip create \
    --compartment-id "$COMPARTMENT_ID" \
    --lifetime "RESERVED" \
    --display-name "$VM_A_1_RPUBIP_NAME" \
    --wait-for-state "AVAILABLE"