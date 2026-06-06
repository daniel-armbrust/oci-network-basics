#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"

TMP_FILE="$(mktemp)"
SHARED_SECRET="$(openssl rand -hex 32)"

#--------#
# VM-A-1 #
#--------#
vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"

echo "$VM_A_1_NAME:$vm_a_1_pub_ip:$SHARED_SECRET:$VM_A_1_VTI_1_IP_MASK:$VM_A_1_VTI_2_IP_MASK" >> $TMP_FILE

#--------#
# VM-B-1 #
#--------#
vm_b_1_pub_ip="$(get_reserved_pub_ip "$VM_B_1_RPUBIP_NAME")"

echo "$VM_B_1_NAME:$vm_b_1_pub_ip:$SHARED_SECRET:$VM_B_1_VTI_1_IP_MASK:$VM_B_1_VTI_2_IP_MASK" >> $TMP_FILE

#--------#
# VM-C-1 #
#--------#
vm_c_1_pub_ip="$(get_reserved_pub_ip "$VM_C_1_RPUBIP_NAME")"

echo "$VM_C_1_NAME:$vm_c_1_pub_ip:$SHARED_SECRET:$VM_C_1_VTI_1_IP_MASK:$VM_C_1_VTI_2_IP_MASK" >> $TMP_FILE

oci os object put \
     --bucket-name "$BUCKET_NAME" \
     --file "$TMP_FILE" \
     --content-type "text/plain" \
     --force \
     --name "$OBJECT_FILE_NAME" \
     --verify-checksum

rm -f "$TMP_FILE"