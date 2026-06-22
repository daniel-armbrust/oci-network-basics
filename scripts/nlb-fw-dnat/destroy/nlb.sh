#!/bin/bash

source "../data.env"
source "../../lib/nlb.sh"

#--------#
# NLB #1 #
#--------#
nlb_1_id="$(get_nlb_id "$NLB_1_NAME")"

oci nlb network-load-balancer delete \
    --network-load-balancer-id "$nlb_1_id" \
    --force \
    --wait-for-state "SUCCEEDED"

#--------#
# NLB #2 #
#--------#
nlb_2_id="$(get_nlb_id "$NLB_2_NAME")"

oci nlb network-load-balancer delete \
    --network-load-balancer-id "$nlb_2_id" \
    --force \
    --wait-for-state "SUCCEEDED"

#--------#
# NLB #3 #
#--------#
nlb_3_id="$(get_nlb_id "$NLB_3_NAME")"

oci nlb network-load-balancer delete \
    --network-load-balancer-id "$nlb_3_id" \
    --force \
    --wait-for-state "SUCCEEDED"