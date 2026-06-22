#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/compute.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_subnpub_id="$(get_subnet_id "$VCN_FRONTEND_SUBNPUB_NAME" "$vcn_frontend_id" "$VCN_FRONTEND_SUBNPUB_CIDR")"

#-------------#
# Firewall #1 #
#-------------#
fw_1_vnic_id="$(get_vnic_id "$FW_1_IP" "$vcn_frontend_subnpub_id")"
fw_1_instance_id="$(get_instance_id "$fw_1_vnic_id")"

oci compute instance terminate \
    --instance-id "$fw_1_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

#-------------#
# Firewall #2 #
#-------------#
fw_2_vnic_id="$(get_vnic_id "$FW_2_IP" "$vcn_frontend_subnpub_id")"
fw_2_instance_id="$(get_instance_id "$fw_2_vnic_id")"

oci compute instance terminate \
    --instance-id "$fw_2_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_subnprv_id="$(get_subnet_id "$VCN_BACKEND_SUBNPRV_NAME" "$vcn_backend_id" "$VCN_BACKEND_SUBNPRV_CIDR")"

#-------------------#
# Backend Server #1 #
#-------------------#
backsrv_1_vnic_id="$(get_vnic_id "$BACKSRV_1_IP" "$vcn_backend_subnprv_id")"
backsrv_1_instance_id="$(get_instance_id "$backsrv_1_vnic_id")"

oci compute instance terminate \
    --instance-id "$backsrv_1_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

#-------------------#
# Backend Server #2 #
#-------------------#
backsrv_2_vnic_id="$(get_vnic_id "$BACKSRV_2_IP" "$vcn_backend_subnprv_id")"
backsrv_2_instance_id="$(get_instance_id "$backsrv_2_vnic_id")"

oci compute instance terminate \
    --instance-id "$backsrv_2_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"

#-------------------#
# Backend Server #3 #
#-------------------#
backsrv_3_vnic_id="$(get_vnic_id "$BACKSRV_3_IP" "$vcn_backend_subnprv_id")"
backsrv_3_instance_id="$(get_instance_id "$backsrv_3_vnic_id")"

oci compute instance terminate \
    --instance-id "$backsrv_3_instance_id" \
    --force \
    --preserve-boot-volume "false" \
    --wait-for-state "SUCCEEDED"