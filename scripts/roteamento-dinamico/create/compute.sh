#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/ad.sh"
source "../../lib/compute.sh"
source "../../lib/reserved_pub_ip.sh"

ad_name="$(get_availability_domain)"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnpub_id="$(get_subnet_id "$VCN_A_SUBNPUB_NAME" "$vcn_a_id" "$VCN_A_SUBNPUB_CIDR")"
vcn_a_subnprv_id="$(get_subnet_id "$VCN_A_SUBNPRV_NAME" "$vcn_a_id" "$VCN_A_SUBNPRV_CIDR")"

# VM-A-1
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_A_1_NAME" \
    --subnet-id "$vcn_a_subnpub_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_A_1_HOSTNAME" \
    --vnic-display-name "$VM_A_1_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$VM_A_1_SHAPE" \
    --shape-config "{\"ocpus\":$VM_A_1_OCPU,\"memoryInGBs\":$VM_A_1_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_A_1_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/vma1-init.sh" \
    --agent-config '{
        "isManagementDisabled": false,
        "isMonitoringDisabled": false,
        "pluginsConfig": [
            {
                "name": "Bastion",
                "desiredState": "ENABLED"
            }
        ]
    }' \
    --wait-for-state "RUNNING"

vm_a_1_vnic_id="$(get_vnic_id "$VM_A_1_IP" "$vcn_a_subnpub_id")"
vm_a_1_private_ip_id="$(get_private_ip_id "$vm_a_1_vnic_id")"
vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"
vm_a_1_pub_ip_id="$(get_reserved_pub_ip_id "$vm_a_1_pub_ip")"

oci network public-ip update \
    --public-ip-id "$vm_a_1_pub_ip_id" \
    --private-ip-id "$vm_a_1_private_ip_id" \
    --force

# VM-A-2
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_A_2_NAME" \
    --subnet-id "$vcn_a_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_A_2_HOSTNAME" \
    --vnic-display-name "$VM_A_2_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$VM_A_2_SHAPE" \
    --shape-config "{\"ocpus\":$VM_A_2_OCPU,\"memoryInGBs\":$VM_A_2_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_A_2_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "../../cloud-init/vm-init.sh" \
    --agent-config '{
        "isManagementDisabled": false,
        "isMonitoringDisabled": false,
        "pluginsConfig": [
            {
                "name": "Bastion",
                "desiredState": "ENABLED"
            }
        ]
    }' \
    --wait-for-state "PROVISIONING"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnpub_id="$(get_subnet_id "$VCN_B_SUBNPUB_NAME" "$vcn_b_id" "$VCN_B_SUBNPUB_CIDR")"
vcn_b_subnprv_id="$(get_subnet_id "$VCN_B_SUBNPRV_NAME" "$vcn_b_id" "$VCN_B_SUBNPRV_CIDR")"

# VM-B-1
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_B_1_NAME" \
    --subnet-id "$vcn_b_subnpub_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_B_1_HOSTNAME" \
    --vnic-display-name "$VM_B_1_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$VM_B_1_SHAPE" \
    --shape-config "{\"ocpus\":$VM_B_1_OCPU,\"memoryInGBs\":$VM_B_1_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_B_1_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/vmb1-init.sh" \
    --agent-config '{
        "isManagementDisabled": false,
        "isMonitoringDisabled": false,
        "pluginsConfig": [
            {
                "name": "Bastion",
                "desiredState": "ENABLED"
            }
        ]
    }' \
    --wait-for-state "RUNNING"

vm_b_1_vnic_id="$(get_vnic_id "$VM_B_1_IP" "$vcn_b_subnpub_id")"
vm_b_1_private_ip_id="$(get_private_ip_id "$vm_b_1_vnic_id")"
vm_b_1_pub_ip="$(get_reserved_pub_ip "$VM_B_1_RPUBIP_NAME")"
vm_b_1_pub_ip_id="$(get_reserved_pub_ip_id "$vm_b_1_pub_ip")"

oci network public-ip update \
    --public-ip-id "$vm_b_1_pub_ip_id" \
    --private-ip-id "$vm_b_1_private_ip_id" \
    --force

# VM-B-2
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_B_2_NAME" \
    --subnet-id "$vcn_b_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_B_2_HOSTNAME" \
    --vnic-display-name "$VM_B_2_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$VM_B_2_SHAPE" \
    --shape-config "{\"ocpus\":$VM_B_2_OCPU,\"memoryInGBs\":$VM_B_2_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_B_2_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "../../cloud-init/vm-init.sh" \
    --agent-config '{
        "isManagementDisabled": false,
        "isMonitoringDisabled": false,
        "pluginsConfig": [
            {
                "name": "Bastion",
                "desiredState": "ENABLED"
            }
        ]
    }' \
    --wait-for-state "PROVISIONING"

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"
vcn_c_subnpub_id="$(get_subnet_id "$VCN_C_SUBNPUB_NAME" "$vcn_c_id" "$VCN_C_SUBNPUB_CIDR")"
vcn_c_subnprv_id="$(get_subnet_id "$VCN_C_SUBNPRV_NAME" "$vcn_c_id" "$VCN_C_SUBNPRV_CIDR")"

# VM-C-1
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_C_1_NAME" \
    --subnet-id "$vcn_c_subnpub_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_C_1_HOSTNAME" \
    --vnic-display-name "$VM_C_1_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$VM_C_1_SHAPE" \
    --shape-config "{\"ocpus\":$VM_C_1_OCPU,\"memoryInGBs\":$VM_C_1_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_C_1_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/vmc1-init.sh" \
    --agent-config '{
        "isManagementDisabled": false,
        "isMonitoringDisabled": false,
        "pluginsConfig": [
            {
                "name": "Bastion",
                "desiredState": "ENABLED"
            }
        ]
    }' \
    --wait-for-state "RUNNING"

vm_c_1_vnic_id="$(get_vnic_id "$VM_C_1_IP" "$vcn_c_subnpub_id")"
vm_c_1_private_ip_id="$(get_private_ip_id "$vm_c_1_vnic_id")"
vm_c_1_pub_ip="$(get_reserved_pub_ip "$VM_C_1_RPUBIP_NAME")"
vm_c_1_pub_ip_id="$(get_reserved_pub_ip_id "$vm_c_1_pub_ip")"

oci network public-ip update \
    --public-ip-id "$vm_c_1_pub_ip_id" \
    --private-ip-id "$vm_c_1_private_ip_id" \
    --force

# VM-C-2
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_C_2_NAME" \
    --subnet-id "$vcn_c_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_C_2_HOSTNAME" \
    --vnic-display-name "$VM_C_2_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$VM_C_2_SHAPE" \
    --shape-config "{\"ocpus\":$VM_C_2_OCPU,\"memoryInGBs\":$VM_C_2_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_C_2_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "../../cloud-init/vm-init.sh" \
    --agent-config '{
        "isManagementDisabled": false,
        "isMonitoringDisabled": false,
        "pluginsConfig": [
            {
                "name": "Bastion",
                "desiredState": "ENABLED"
            }
        ]
    }' \
    --wait-for-state "PROVISIONING"