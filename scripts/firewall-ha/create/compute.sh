#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/ad.sh"
source "../../lib/compute.sh"

ad_name="$(get_availability_domain)"
vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_id="$(get_subnet_id "$SUBNPRV_NAME" "$vcn_id" "$SUBNPRV_CIDR")"

# FW-1
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$FW_1_NAME" \
    --subnet-id "$vcn_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$FW_1_HOSTNAME" \
    --vnic-display-name "$FW_1_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$FW_1_SHAPE" \
    --shape-config "{\"ocpus\":$FW_1_OCPU,\"memoryInGBs\":$FW_1_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$FW_1_IP" \
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
    --wait-for-state "RUNNING"

# FW-2
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$FW_2_NAME" \
    --subnet-id "$vcn_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$FW_2_HOSTNAME" \
    --vnic-display-name "$FW_2_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$FW_2_SHAPE" \
    --shape-config "{\"ocpus\":$FW_2_OCPU,\"memoryInGBs\":$FW_2_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$FW_2_IP" \
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
    --wait-for-state "RUNNING"