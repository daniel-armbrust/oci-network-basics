#!/bin/bash

source "../network.env"
source "../lib/vcn.sh"
source "../lib/route_table.sh"
source "../lib/gateway.sh"
source "../lib/drg.sh"
source "../lib/compute.sh"
source "../lib/subnet.sh"

drg_id="$(get_drg_id "$DRG_NAME")"

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
             "networkEntityId": "'"$drg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$vcn_a_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'

#----------------#
# VCN-B / SUBNET #
#----------------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"
vcn_b_subnprv_rt_id="$(get_route_table_id "$VCN_B_SUBNPRV_RT_NAME" "$vcn_b_id")"
vcn_b_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_b_id")"

oci network route-table update \
    --rt-id "$vcn_b_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$drg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$vcn_b_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination": "all-gru-services-in-oracle-services-network"
         }
    ]'

#-----------------------#
# VCN-FIREWALL / SUBNET #
#-----------------------#
vcn_firewall_id="$(get_vcn_id "$VCN_FIREWALL_NAME" "$VCN_FIREWALL_CIDR")"
vcn_firewall_subnprv_rt_id="$(get_route_table_id "$VCN_FIREWALL_SUBNPRV_RT_NAME" "$vcn_firewall_id")"
vcn_firewall_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_firewall_id")"
vcn_firewall_ngw_id="$(get_ngw_id "$NGW_NAME" "$vcn_firewall_id")"

oci network route-table update \
    --rt-id "$vcn_firewall_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$drg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_A_CIDR"'"
         },
         {
             "networkEntityId": "'"$drg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_B_CIDR"'"
         },
         {
             "networkEntityId": "'"$vcn_firewall_sgw_id"'",
             "destinationType": "SERVICE_CIDR_BLOCK",
             "destination":"all-gru-services-in-oracle-services-network"
         },
         {
             "networkEntityId": "'"$vcn_firewall_ngw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

# TO-FIREWALL-IP
vcn_firewall_subnprv_id="$(get_subnet_id "$VCN_FIREWALL_SUBNPRV_NAME" "$vcn_firewall_id" "$VCN_FIREWALL_SUBNPRV_CIDR")"
firewall_vnic_id="$(get_vnic_id "$FIREWALL_IP" "$vcn_firewall_subnprv_id")"
vcn_firewall_to_firewall_ip_rt_id="$(get_route_table_id "$VCN_FIREWALL_TO_FIREWALL_IP_RT_NAME" "$vcn_firewall_id")"
firewall_private_ip_id="$(get_private_ip_id "$firewall_vnic_id")"

oci network route-table update \
    --rt-id "$vcn_firewall_to_firewall_ip_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$firewall_private_ip_id"'",
             "destinationType":"CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

#-------------------#
# DRG / TO-FIREWALL #
#-------------------#
imprtdst_to_firewall_id="$(get_drg_imprtdst_id "$DRG_IMPRT_TO_FIREWALL_NAME" "$drg_id")"
to_firewall_rt_id="$(get_drg_rt_id "$DRG_RT_TO_FIREWALL_NAME" "$drg_id" "$imprtdst_to_firewall_id")"
vcn_firewall_drg_attch_id="$(get_drg_attch_id "$VCN_FIREWALL_DRGATTCH_NAME" "$drg_id" "$vcn_firewall_id")"

oci network drg-route-rule add \
    --drg-route-table-id "$to_firewall_rt_id" \
    --route-rules '[
        { 
            "destination": "0.0.0.0/0",
            "destinationType": "CIDR_BLOCK",
            "nextHopDrgAttachmentId": "'"$vcn_firewall_drg_attch_id"'"
        }
    ]'