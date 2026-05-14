#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/gateway.sh"
source "../../lib/drg.sh"
source "../../lib/compute.sh"
source "../../lib/subnet.sh"
source "../../lib/lpg.sh"

drg_1_id="$(get_drg_id "$DRG_1_NAME")"
drg_2_id="$(get_drg_id "$DRG_2_NAME")"

#----------------#
# VCN-A / SUBNET #
#----------------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnprv_rt_id="$(get_route_table_id "$VCN_A_SUBNPRV_RT_NAME" "$vcn_a_id")"
vcn_a_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_a_id")"

oci network route-table update \
    --rt-id "$vcn_a_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$drg_1_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$vcn_a_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'

#------------------#
# VCN-HUB / SUBNET #
#------------------#
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"
vcn_hub_subnprv_rt_id="$(get_route_table_id "$VCN_HUB_SUBNPRV_RT_NAME" "$vcn_hub_id")"
vcn_hub_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_hub_id")"

oci network route-table update \
    --rt-id "$vcn_hub_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$drg_2_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$vcn_hub_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'

#---------------#
# VCN-HUB / LPG #
#---------------#
vcn_hub_vcn_firewall_lpg_rt_id="$(get_route_table_id "$VCN_HUB_VCN_FIREWALL_LPG_RT_NAME" "$vcn_hub_id")"
vcn_hub_vcn_firewall_lpg_id="$(get_lpg_id "$VCN_HUB_VCN_FIREWALL_LPG_NAME" "$vcn_hub_id")"

vcn_hub_subnprv_id="$(get_subnet_id "$VCN_HUB_SUBNPRV_NAME" "$vcn_hub_id" "$VCN_HUB_SUBNPRV_CIDR")"
vm_hub_vnic_id="$(get_vnic_id "$VM_HUB_IP" "$vcn_hub_subnprv_id")"

vm_hub_private_ip_id="$(get_private_ip_id "$vm_hub_vnic_id")"

oci network route-table update \
    --rt-id "$vcn_hub_vcn_firewall_lpg_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$drg_2_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_A_SUBNPRV_CIDR"'"
         }
    ]'

# TO-FIREWALL-LPG
vcn_hub_rt_id="$(get_route_table_id "$VCN_HUB_RT_DRG_NAME" "$vcn_hub_id")"

oci network route-table update \
    --rt-id "$vcn_hub_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_hub_vcn_firewall_lpg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

#-----------------------#
# VCN-FIREWALL / SUBNET #
#-----------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_rt_id="$(get_route_table_id "$VCN_FIREWALL_SUBNPRV_RT_NAME" "$vcn_firewall_id")"

vcn_firewall_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_firewall_id")"
vcn_firewall_ngw_id="$(get_ngw_id "$NGW_NAME" "$vcn_firewall_id")"
vcn_firewall_vcn_hub_lpg_id="$(get_lpg_id "$VCN_FIREWALL_VCN_HUB_LPG_NAME" "$vcn_firewall_id")"

oci network route-table update \
    --rt-id "$vcn_firewall_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_firewall_vcn_hub_lpg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_HUB_SUBNPRV_CIDR"'"
         },
         {
             "networkEntityId": "'"$vcn_firewall_vcn_hub_lpg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_A_SUBNPRV_CIDR"'"
         },
         {
             "networkEntityId": "'"$vcn_firewall_vcn_hub_lpg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_B_SUBNPRV_CIDR"'"
         },
         {
             "networkEntityId": "'"$vcn_firewall_ngw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination":  "0.0.0.0/0"
         }
    ]'

#--------------------#
# VCN-FIREWALL / LPG #
#--------------------#
vcn_firewall_vcn_hub_lpg_rt_id="$(get_route_table_id "$VCN_FIREWALL_VCN_HUB_LPG_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_vcn_hub_lpg_id="$(get_lpg_id "$VCN_FIREWALL_VCN_HUB_LPG_NAME" "$vcn_firewall_id")"

vcn_firewall_subnprv_id="$(get_subnet_id "$VCN_FIREWALL_SUBNPRV_NAME" "$vcn_firewall_id" "$VCN_FIREWALL_SUBNPRV_CIDR")"
vm_firewall_vnic_id="$(get_vnic_id "$FIREWALL_IP" "$vcn_firewall_subnprv_id")"

vm_firewall_private_ip_id="$(get_private_ip_id "$vm_firewall_vnic_id")"

oci network route-table update \
    --rt-id "$vcn_firewall_vcn_hub_lpg_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vm_firewall_private_ip_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

#----------------#
# VCN-B / SUBNET #
#----------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"
vcn_b_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_b_id")"
vcn_b_vcn_firewall_lpg_id="$(get_lpg_id "$VCN_B_VCN_FIREWALL_LPG_NAME" "$vcn_b_id")"

oci network route-table update \
    --rt-id "$vcn_b_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_b_vcn_firewall_lpg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$vcn_b_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'