#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/ad.sh"
source "../../lib/compute.sh"
source "../../lib/reserved_pub_ip.sh"
source "../../lib/nlb.sh"

ad_name="$(get_availability_domain)"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
vcn_frontend_subnpub_id="$(get_subnet_id "$VCN_FRONTEND_SUBNPUB_NAME" "$vcn_frontend_id" "$VCN_FRONTEND_SUBNPUB_CIDR")"

# Firewall-1
fw_1_vnic_id="$(get_vnic_id "$FW_1_IP" "$vcn_frontend_subnpub_id")"
fw_1_private_ip_id="$(get_private_ip_id "$fw_1_vnic_id")"

# Firewall-2
fw_2_vnic_id="$(get_vnic_id "$FW_2_IP" "$vcn_frontend_subnpub_id")"
fw_2_private_ip_id="$(get_private_ip_id "$fw_2_vnic_id")"

#--------#
# NLB #1 #
#--------#
nlb_1_pub_ip="$(get_reserved_pub_ip "$NLB_1_RPUBIP_NAME")"
nlb_1_pub_ip_id="$(get_reserved_pub_ip_id "$nlb_1_pub_ip")"

oci nlb network-load-balancer create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$NLB_1_NAME" \
    --subnet-id "$vcn_frontend_subnpub_id" \
    --assigned-private-ipv4 "$NLB_1_PRIVATE_IP" \
    --is-preserve-source-destination "true" \
    --is-private "false" \
    --is-symmetric-hash-enabled "true" \
    --nlb-ip-version "IPV4" \
    --reserved-ips "[{\"id\": \"$nlb_1_pub_ip_id\"}]" \
    --wait-for-state "SUCCEEDED"

# NLB
nlb_1_id="$(get_nlb_id "$NLB_1_NAME")"

# Backend Set
oci nlb backend-set create \
    --name "$NLB_1_BACKSET_NAME" \
    --network-load-balancer-id "$nlb_1_id" \
    --policy "THREE_TUPLE" \
    --ip-version "IPV4" \
    --is-preserve-source "true" \
    --is-instant-failover-enabled "true" \
    --is-instant-failover-tcp-reset-enabled "true" \
    --backends "[
        {
            \"isBackup\": false,
            \"isDrain\": false,
            \"isOffline\": false,
            \"name\": \"$FW_1_NAME\",
            \"port\": 0,
            \"targetId\": \"$fw_1_private_ip_id\",
            \"weight\": 1
        },
        {
            \"isBackup\": true,
            \"isDrain\": false,
            \"isOffline\": false,
            \"name\": \"$FW_2_NAME\",
            \"port\": 0,
            \"targetId\": \"$fw_2_private_ip_id\",
            \"weight\": 1
        }]" \
    --health-checker '{
        "protocol":"TCP",
        "port":22,
        "retries":3,
        "timeoutInMillis":3000,
        "intervalInMillis":10000
    }' \
    --wait-for-state "SUCCEEDED"

# Listener
oci nlb listener create \
    --default-backend-set-name "$NLB_1_BACKSET_NAME" \
    --name "$NLB_1_LISTENER_NAME" \
    --network-load-balancer-id "$nlb_1_id" \
    --protocol "L3IP" \
    --port "0" \
    --ip-version "IPV4" \
    --wait-for-state "SUCCEEDED"

#--------#
# NLB #2 #
#--------#
nlb_2_pub_ip="$(get_reserved_pub_ip "$NLB_2_RPUBIP_NAME")"
nlb_2_pub_ip_id="$(get_reserved_pub_ip_id "$nlb_2_pub_ip")"

oci nlb network-load-balancer create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$NLB_2_NAME" \
    --subnet-id "$vcn_frontend_subnpub_id" \
    --assigned-private-ipv4 "$NLB_2_PRIVATE_IP" \
    --is-preserve-source-destination "true" \
    --is-private "false" \
    --is-symmetric-hash-enabled "true" \
    --nlb-ip-version "IPV4" \
    --reserved-ips "[{\"id\": \"$nlb_2_pub_ip_id\"}]" \
    --wait-for-state "SUCCEEDED"

# NLB
nlb_2_id="$(get_nlb_id "$NLB_2_NAME")"

# Backend Set
oci nlb backend-set create \
    --name "$NLB_2_BACKSET_NAME" \
    --network-load-balancer-id "$nlb_2_id" \
    --policy "THREE_TUPLE" \
    --ip-version "IPV4" \
    --is-preserve-source "true" \
    --is-instant-failover-enabled "true" \
    --is-instant-failover-tcp-reset-enabled "true" \
    --backends "[
        {
            \"isBackup\": false,
            \"isDrain\": false,
            \"isOffline\": false,
            \"name\": \"$FW_1_NAME\",
            \"port\": 0,
            \"targetId\": \"$fw_1_private_ip_id\",
            \"weight\": 1
        },
        {
            \"isBackup\": true,
            \"isDrain\": false,
            \"isOffline\": false,
            \"name\": \"$FW_2_NAME\",
            \"port\": 0,
            \"targetId\": \"$fw_2_private_ip_id\",
            \"weight\": 1
        }]" \
    --health-checker '{
        "protocol":"TCP",
        "port":22,
        "retries":3,
        "timeoutInMillis":3000,
        "intervalInMillis":10000
    }' \
    --wait-for-state "SUCCEEDED"

# Listener
oci nlb listener create \
    --default-backend-set-name "$NLB_2_BACKSET_NAME" \
    --name "$NLB_2_LISTENER_NAME" \
    --network-load-balancer-id "$nlb_2_id" \
    --protocol "L3IP" \
    --port "0" \
    --ip-version "IPV4" \
    --wait-for-state "SUCCEEDED"

#--------#
# NLB #3 #
#--------#
nlb_3_pub_ip="$(get_reserved_pub_ip "$NLB_3_RPUBIP_NAME")"
nlb_3_pub_ip_id="$(get_reserved_pub_ip_id "$nlb_3_pub_ip")"

oci nlb network-load-balancer create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$NLB_3_NAME" \
    --subnet-id "$vcn_frontend_subnpub_id" \
    --assigned-private-ipv4 "$NLB_3_PRIVATE_IP" \
    --is-preserve-source-destination "true" \
    --is-private "false" \
    --is-symmetric-hash-enabled "true" \
    --nlb-ip-version "IPV4" \
    --reserved-ips "[{\"id\": \"$nlb_3_pub_ip_id\"}]" \
    --wait-for-state "SUCCEEDED"

# NLB
nlb_3_id="$(get_nlb_id "$NLB_3_NAME")"

# Backend Set
oci nlb backend-set create \
    --name "$NLB_3_BACKSET_NAME" \
    --network-load-balancer-id "$nlb_3_id" \
    --policy "THREE_TUPLE" \
    --ip-version "IPV4" \
    --is-preserve-source "true" \
    --is-instant-failover-enabled "true" \
    --is-instant-failover-tcp-reset-enabled "true" \
    --backends "[
        {
            \"isBackup\": false,
            \"isDrain\": false,
            \"isOffline\": false,
            \"name\": \"$FW_1_NAME\",
            \"port\": 0,
            \"targetId\": \"$fw_1_private_ip_id\",
            \"weight\": 1
        },
        {
            \"isBackup\": true,
            \"isDrain\": false,
            \"isOffline\": false,
            \"name\": \"$FW_2_NAME\",
            \"port\": 0,
            \"targetId\": \"$fw_2_private_ip_id\",
            \"weight\": 1
        }]" \
    --health-checker '{
        "protocol":"TCP",
        "port":22,
        "retries":3,
        "timeoutInMillis":3000,
        "intervalInMillis":10000
    }' \
    --wait-for-state "SUCCEEDED"

# Listener
oci nlb listener create \
    --default-backend-set-name "$NLB_3_BACKSET_NAME" \
    --name "$NLB_3_LISTENER_NAME" \
    --network-load-balancer-id "$nlb_3_id" \
    --protocol "L3IP" \
    --port "0" \
    --ip-version "IPV4" \
    --wait-for-state "SUCCEEDED"