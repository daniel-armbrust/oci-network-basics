#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/subnet.sh"
source "../lib/ad.sh"

ad_name="$(get_availability_domain)"

#--------------#
# VCN-A / VM-A #
#--------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_id="$(get_subnet_id "$VCN_A_SUBNPRV_NAME" "$vcn_a_id" "$VCN_A_SUBNPRV_CIDR")"

oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_A_NAME" \
    --subnet-id "$vcn_a_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_A_HOSTNAME" \
    --vnic-display-name "$VM_A_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL10_ARM_ID" \
    --shape "$VM_A_SHAPE" \
    --shape-config "{\"ocpus\":$VM_A_OCPU,\"memoryInGBs\":$VM_A_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_A_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/vm-a.sh" \
    --wait-for-state "PROVISIONING"

#--------------#
# VCN-B / VM-B #
#--------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_id="$(get_subnet_id "$VCN_B_SUBNPRV_NAME" "$vcn_b_id" "$VCN_B_SUBNPRV_CIDR")"

oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$VM_B_NAME" \
    --subnet-id "$vcn_b_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$VM_B_HOSTNAME" \
    --vnic-display-name "$VM_B_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL10_ARM_ID" \
    --shape "$VM_B_SHAPE" \
    --shape-config "{\"ocpus\":$VM_B_OCPU,\"memoryInGBs\":$VM_B_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$VM_B_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/vm-b.sh" \
    --wait-for-state "PROVISIONING"

#-------------------------#
# VCN-FIREWALL / FIREWALL #
#-------------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_id="$(get_subnet_id "$VCN_FIREWALL_SUBNPRV_NAME" "$vcn_firewall_id" "$VCN_FIREWALL_SUBNPRV_CIDR")"

oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$FIREWALL_NAME" \
    --subnet-id "$vcn_firewall_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$FIREWALL_HOSTNAME" \
    --vnic-display-name "$FIREWALL_VNIC_NAME" \
    --boot-volume-size-in-gbs "100" \
    --image-id "$ORL10_ARM_ID" \
    --shape "$FIREWALL_SHAPE" \
    --shape-config "{\"ocpus\":$FIREWALL_OCPU,\"memoryInGBs\":$FIREWALL_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$FIREWALL_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/firewall.sh" \
    --wait-for-state "RUNNING"

