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
    --wait-for-state "SUCCEEDED"

# VM-A-2
vcn_a_subnprv_id="$(get_subnet_id "$VCN_A_SUBNPRV_NAME" "$vcn_a_id" "$VCN_A_SUBNPRV_CIDR")"
vm_a_2_vnic_id="$(get_vnic_id "$VM_A_2_IP" "$vcn_a_subnprv_id")"
vm_a_2_instance_id="$(get_instance_id "$vm_a_2_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_a_2_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

# VM-B-1
vcn_b_subnpub_id="$(get_subnet_id "$VCN_B_SUBNPUB_NAME" "$vcn_b_id" "$VCN_B_SUBNPUB_CIDR")"
vm_b_1_vnic_id="$(get_vnic_id "$VM_B_1_IP" "$vcn_b_subnpub_id")"
vm_b_1_instance_id="$(get_instance_id "$vm_b_1_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_b_1_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

# VM-B-2
vcn_b_subnprv_id="$(get_subnet_id "$VCN_B_SUBNPRV_NAME" "$vcn_b_id" "$VCN_B_SUBNPRV_CIDR")"
vm_b_2_vnic_id="$(get_vnic_id "$VM_B_2_IP" "$vcn_b_subnprv_id")"
vm_b_2_instance_id="$(get_instance_id "$vm_b_2_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_b_2_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

# VM-C-1
vcn_c_subnpub_id="$(get_subnet_id "$VCN_C_SUBNPUB_NAME" "$vcn_c_id" "$VCN_C_SUBNPUB_CIDR")"
vm_c_1_vnic_id="$(get_vnic_id "$VM_C_1_IP" "$vcn_c_subnpub_id")"
vm_c_1_instance_id="$(get_instance_id "$vm_c_1_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_c_1_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

# VM-C-2
vcn_c_subnprv_id="$(get_subnet_id "$VCN_C_SUBNPRV_NAME" "$vcn_c_id" "$VCN_C_SUBNPRV_CIDR")"
vm_c_2_vnic_id="$(get_vnic_id "$VM_C_2_IP" "$vcn_c_subnprv_id")"
vm_c_2_instance_id="$(get_instance_id "$vm_c_2_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_c_2_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"