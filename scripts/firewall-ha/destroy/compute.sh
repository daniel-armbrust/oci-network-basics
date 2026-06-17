#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/compute.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_id="$(get_subnet_id "$SUBNPRV_NAME" "$vcn_id" "$SUBNPRV_CIDR")"

# FW-1
fw_1_vnic_id="$(get_vnic_id "$FW_1_IP" "$vcn_subnprv_id")"
fw_1_instance_id="$(get_instance_id "$fw_1_vnic_id")"

oci compute instance terminate \
    --instance-id "$fw_1_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

# FW-2
fw_2_vnic_id="$(get_vnic_id "$FW_2_IP" "$vcn_subnprv_id")"
fw_2_instance_id="$(get_instance_id "$fw_2_vnic_id")"

oci compute instance terminate \
    --instance-id "$fw_2_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"