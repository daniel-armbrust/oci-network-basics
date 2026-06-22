#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/ad.sh"
source "../../lib/compute.sh"

ad_name="$(get_availability_domain)"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_subnpub_id="$(get_subnet_id "$VCN_FRONTEND_SUBNPUB_NAME" "$vcn_frontend_id" "$VCN_FRONTEND_SUBNPUB_CIDR")"

#-------------#
# Firewall #1 #
#-------------#
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$FW_1_NAME" \
    --subnet-id "$vcn_frontend_subnpub_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$FW_1_HOSTNAME" \
    --vnic-display-name "$FW_1_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$FW_1_SHAPE" \
    --shape-config "{\"ocpus\":$FW_1_OCPU,\"memoryInGBs\":$FW_1_MEM}" \
    --assign-public-ip "true" \
    --private-ip "$FW_1_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/firewall-init.sh" \
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
    --wait-for-state "RUNNING" \
    --wait-interval-seconds "10"

#-------------#
# Firewall #2 #
#-------------#
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$FW_2_NAME" \
    --subnet-id "$vcn_frontend_subnpub_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$FW_2_HOSTNAME" \
    --vnic-display-name "$FW_2_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$FW_2_SHAPE" \
    --shape-config "{\"ocpus\":$FW_2_OCPU,\"memoryInGBs\":$FW_2_MEM}" \
    --assign-public-ip "true" \
    --private-ip "$FW_2_IP" \
    --skip-source-dest-check "true" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/firewall-init.sh" \
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
    --wait-for-state "RUNNING" \
    --wait-interval-seconds "10"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_subnprv_id="$(get_subnet_id "$VCN_BACKEND_SUBNPRV_NAME" "$vcn_backend_id" "$VCN_BACKEND_SUBNPRV_CIDR")"

#-------------------#
# Backend Server #1 #
#-------------------#
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$BACKSRV_1_NAME" \
    --subnet-id "$vcn_backend_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$BACKSRV_1_HOSTNAME" \
    --vnic-display-name "$BACKSRV_1_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$BACKSRV_1_SHAPE" \
    --shape-config "{\"ocpus\":$BACKSRV_1_OCPU,\"memoryInGBs\":$BACKSRV_1_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$BACKSRV_1_IP" \
    --skip-source-dest-check "false" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/backend-init.sh" \
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
    --wait-for-state "RUNNING" \
    --wait-interval-seconds "10"

#-------------------#
# Backend Server #2 #
#-------------------#
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$BACKSRV_2_NAME" \
    --subnet-id "$vcn_backend_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$BACKSRV_2_HOSTNAME" \
    --vnic-display-name "$BACKSRV_2_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$BACKSRV_2_SHAPE" \
    --shape-config "{\"ocpus\":$BACKSRV_2_OCPU,\"memoryInGBs\":$BACKSRV_2_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$BACKSRV_2_IP" \
    --skip-source-dest-check "false" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/backend-init.sh" \
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
    --wait-for-state "RUNNING" \
    --wait-interval-seconds "10"

#-------------------#
# Backend Server #3 #
#-------------------#
oci compute instance launch \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$BACKSRV_3_NAME" \
    --subnet-id "$vcn_backend_subnprv_id" \
    --availability-domain "$ad_name" \
    --hostname-label "$BACKSRV_3_HOSTNAME" \
    --vnic-display-name "$BACKSRV_3_VNIC_NAME" \
    --boot-volume-size-in-gbs "50" \
    --image-id "$ORL8_ARM_ID" \
    --shape "$BACKSRV_3_SHAPE" \
    --shape-config "{\"ocpus\":$BACKSRV_3_OCPU,\"memoryInGBs\":$BACKSRV_3_MEM}" \
    --assign-public-ip "false" \
    --private-ip "$BACKSRV_3_IP" \
    --skip-source-dest-check "false" \
    --ssh-authorized-keys-file "$SSH_PUB_KEY_PATH" \
    --user-data-file "cloud-init/backend-init.sh" \
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
    --wait-for-state "RUNNING" \
    --wait-interval-seconds "10"