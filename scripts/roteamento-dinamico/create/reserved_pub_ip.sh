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

vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"

#--------#
# VM-B-1 #
#--------#
oci network public-ip create \
    --compartment-id "$COMPARTMENT_ID" \
    --lifetime "RESERVED" \
    --display-name "$VM_B_1_RPUBIP_NAME" \
    --wait-for-state "AVAILABLE"

vm_b_1_pub_ip="$(get_reserved_pub_ip "$VM_B_1_RPUBIP_NAME")"

#--------#
# VM-C-1 #
#--------#
oci network public-ip create \
    --compartment-id "$COMPARTMENT_ID" \
    --lifetime "RESERVED" \
    --display-name "$VM_C_1_RPUBIP_NAME" \
    --wait-for-state "AVAILABLE"

vm_c_1_pub_ip="$(get_reserved_pub_ip "$VM_C_1_RPUBIP_NAME")"