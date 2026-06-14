#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/compute.sh"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# VM-A-1
vcn_a_subnpub_id="$(get_subnet_id "$VCN_A_SUBNPUB_NAME" "$vcn_a_id" "$VCN_A_SUBNPUB_CIDR")"
vm_a_1_vnic_id="$(get_vnic_id "$VM_A_1_IP" "$vcn_a_subnpub_id")"
vm_a_1_instance_id="$(get_instance_id "$vm_a_1_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_a_1_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "TERMINATED"