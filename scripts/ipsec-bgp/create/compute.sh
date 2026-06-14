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
    --user-data-file "cloud-init/armfw-setup.sh" \
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