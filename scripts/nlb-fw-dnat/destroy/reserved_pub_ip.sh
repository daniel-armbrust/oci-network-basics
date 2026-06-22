#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"

#--------#
# NLB #1 #
#--------#
nlb_1_pub_ip="$(get_reserved_pub_ip "$NLB_1_RPUBIP_NAME")"
nlb_1_pub_ip_id="$(get_reserved_pub_ip_id "$nlb_1_pub_ip")"

oci network public-ip delete \
    --public-ip-id "$nlb_1_pub_ip_id" \
    --force \
    --wait-for-state "TERMINATED"

#--------#
# NLB #2 #
#--------#
nlb_2_pub_ip="$(get_reserved_pub_ip "$NLB_2_RPUBIP_NAME")"
nlb_2_pub_ip_id="$(get_reserved_pub_ip_id "$nlb_2_pub_ip")"

oci network public-ip delete \
    --public-ip-id "$nlb_2_pub_ip_id" \
    --force \
    --wait-for-state "TERMINATED"

#--------#
# NLB #3 #
#--------#
nlb_3_pub_ip="$(get_reserved_pub_ip "$NLB_3_RPUBIP_NAME")"
nlb_3_pub_ip_id="$(get_reserved_pub_ip_id "$nlb_3_pub_ip")"

oci network public-ip delete \
    --public-ip-id "$nlb_3_pub_ip_id" \
    --force \
    --wait-for-state "TERMINATED"