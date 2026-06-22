#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/gateway.sh"
source "../../lib/drg.sh"
source "../../lib/compute.sh"
source "../../lib/subnet.sh"

drg_id="$(get_drg_id "$DRG_NAME")"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_subnpub_rt_id="$(get_route_table_id "$VCN_FRONTEND_SUBNPUB_RT_NAME" "$vcn_frontend_id")"
vcn_frontend_igw_id="$(get_igw_id "$IGW_NAME" "$vcn_frontend_id")"

oci network route-table update \
    --rt-id "$vcn_frontend_subnpub_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$vcn_frontend_igw_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination":  "0.0.0.0/0"
         },
         {
             "networkEntityId": "'"$drg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "'"$VCN_BACKEND_CIDR"'"
         }
    ]'

# TO-FIREWALL-IP
vcn_frontend_subnpub_id="$(get_subnet_id "$VCN_FRONTEND_SUBNPUB_NAME" "$vcn_frontend_id" "$VCN_FRONTEND_SUBNPUB_CIDR")"
fw_1_vnic_id="$(get_vnic_id "$FW_1_IP" "$vcn_frontend_subnpub_id")"
vcn_frontend_to_firewall_ip_rt_id="$(get_route_table_id "$VCN_FRONTEND_TO_FIREWALL_IP_RT_NAME" "$vcn_frontend_id")"
fw_1_private_ip_id="$(get_private_ip_id "$fw_1_vnic_id")"

oci network route-table update \
    --rt-id "$vcn_frontend_to_firewall_ip_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
         {
             "networkEntityId": "'"$fw_1_private_ip_id"'",
             "destinationType":"CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'

# DRG / TO-FIREWALL
imprtdst_to_firewall_id="$(get_drg_imprtdst_id "$DRG_IMPRT_TO_FIREWALL_NAME" "$drg_id")"
to_firewall_rt_id="$(get_drg_rt_id "$DRG_RT_TO_FIREWALL_NAME" "$drg_id" "$imprtdst_to_firewall_id")"
vcn_frontend_drg_attch_id="$(get_drg_attch_id "$VCN_FRONTEND_DRGATTCH_NAME" "$drg_id" "$vcn_frontend_id")"

oci network drg-route-rule add \
    --drg-route-table-id "$to_firewall_rt_id" \
    --route-rules '[
        { 
            "destination": "0.0.0.0/0",
            "destinationType": "CIDR_BLOCK",
            "nextHopDrgAttachmentId": "'"$vcn_frontend_drg_attch_id"'"
        }
    ]'

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"
vcn_backend_subnprv_rt_id="$(get_route_table_id "$VCN_BACKEND_SUBNPRV_RT_NAME" "$vcn_backend_id")"
vcn_backend_sgw_id="$(get_sgw_id "$SGW_NAME" "$vcn_backend_id")"

oci network route-table update \
    --rt-id "$vcn_backend_subnprv_rt_id" \
    --force \
    --wait-for-state "AVAILABLE" \
    --route-rules '[
        {
            "networkEntityId": "'"$vcn_backend_sgw_id"'",
            "destinationType": "SERVICE_CIDR_BLOCK",
            "destination": "all-gru-services-in-oracle-services-network"
        },
        {
             "networkEntityId": "'"$drg_id"'",
             "destinationType": "CIDR_BLOCK",
             "destination": "0.0.0.0/0"
         }
    ]'