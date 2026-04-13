#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/subnet.sh"
source "../lib/compute.sh"

#--------------#
# VCN-A / VM-A #
#--------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_id="$(get_subnet_id "$VCN_A_SUBNPRV_NAME" "$vcn_a_id" "$VCN_A_SUBNPRV_CIDR")"
vm_a_vnic_id="$(get_vnic_id "$VM_A_IP" "$vcn_a_subnprv_id")"
vm_a_instance_id="$(get_instance_id "$vm_a_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_a_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "TERMINATED"

#--------------#
# VCN-B / VM-B #
#--------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_id="$(get_subnet_id "$VCN_B_SUBNPRV_NAME" "$vcn_b_id" "$VCN_B_SUBNPRV_CIDR")"
vm_b_vnic_id="$(get_vnic_id "$VM_B_IP" "$vcn_b_subnprv_id")"
vm_b_instance_id="$(get_instance_id "$vm_b_vnic_id")"

oci compute instance terminate \
    --instance-id "$vm_b_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "TERMINATED"

#-------------------------#
# VCN-FIREWALL / FIREWALL #
#-------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_id="$(get_subnet_id "$VCN_FIREWALL_SUBNPRV_NAME" "$vcn_firewall_id" "$VCN_FIREWALL_SUBNPRV_CIDR")"
firewall_vnic_id="$(get_vnic_id "$FIREWALL_IP" "$vcn_firewall_subnprv_id")"
firewall_instance_id="$(get_instance_id "$firewall_vnic_id")"

oci compute instance terminate \
    --instance-id "$firewall_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "TERMINATED"