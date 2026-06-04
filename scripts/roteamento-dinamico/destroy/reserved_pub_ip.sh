#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"

#--------#
# VM-A-1 #
#--------#
vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"
vm_a_1_pub_ip_id="$(get_reserved_pub_ip_id "$vm_a_1_pub_ip")"

oci network public-ip delete \
    --public-ip-id "$vm_a_1_pub_ip_id" \
    --force \
    --wait-for-state "TERMINATED"

#--------#
# VM-B-1 #
#--------#
vm_b_1_pub_ip="$(get_reserved_pub_ip "$VM_B_1_RPUBIP_NAME")"
vm_b_1_pub_ip_id="$(get_reserved_pub_ip_id "$vm_b_1_pub_ip")"

oci network public-ip delete \
    --public-ip-id "$vm_b_1_pub_ip_id" \
    --force \
    --wait-for-state "TERMINATED"

#--------#
# VM-C-1 #
#--------#
vm_c_1_pub_ip="$(get_reserved_pub_ip "$VM_C_1_RPUBIP_NAME")"
vm_c_1_pub_ip_id="$(get_reserved_pub_ip_id "$vm_c_1_pub_ip")"

oci network public-ip delete \
    --public-ip-id "$vm_c_1_pub_ip_id" \
    --force \
    --wait-for-state "TERMINATED"