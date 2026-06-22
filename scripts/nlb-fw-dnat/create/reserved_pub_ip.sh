#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"

#--------#
# NLB #1 #
#--------#
oci network public-ip create \
    --compartment-id "$COMPARTMENT_ID" \
    --lifetime "RESERVED" \
    --display-name "$NLB_1_RPUBIP_NAME" \
    --wait-for-state "AVAILABLE"

#--------#
# NLB #2 #
#--------#
oci network public-ip create \
    --compartment-id "$COMPARTMENT_ID" \
    --lifetime "RESERVED" \
    --display-name "$NLB_2_RPUBIP_NAME" \
    --wait-for-state "AVAILABLE"

#--------#
# NLB #3 #
#--------#
oci network public-ip create \
    --compartment-id "$COMPARTMENT_ID" \
    --lifetime "RESERVED" \
    --display-name "$NLB_3_RPUBIP_NAME" \
    --wait-for-state "AVAILABLE"