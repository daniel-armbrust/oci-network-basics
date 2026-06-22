#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"
source "../../lib/nlb.sh"

TMP_FILE="$(mktemp)"

#--------#
# NLB #1 #
#--------#
nlb_1_pub_ip="$(get_reserved_pub_ip "$NLB_1_RPUBIP_NAME")"

echo "NLB_1_PUB_IP:$nlb_1_pub_ip" >> "$TMP_FILE"
echo "NLB_1_PRV_IP:$NLB_1_PRIVATE_IP" >> "$TMP_FILE"

#--------#
# NLB #2 #
#--------#
nlb_2_pub_ip="$(get_reserved_pub_ip "$NLB_2_RPUBIP_NAME")"

echo "NLB_2_PUB_IP:$nlb_2_pub_ip" >> "$TMP_FILE"
echo "NLB_2_PRV_IP:$NLB_2_PRIVATE_IP" >> "$TMP_FILE"

#--------#
# NLB #3 #
#--------#
nlb_3_pub_ip="$(get_reserved_pub_ip "$NLB_3_RPUBIP_NAME")"

echo "NLB_3_PUB_IP:$nlb_3_pub_ip" >> "$TMP_FILE"
echo "NLB_3_PRV_IP:$NLB_3_PRIVATE_IP" >> "$TMP_FILE"

#-------------------#
# Backend Server #1 #
#-------------------#
echo "BACKSRV_1_IP:$BACKSRV_1_IP" >> "$TMP_FILE"

#-------------------#
# Backend Server #2 #
#-------------------#
echo "BACKSRV_2_IP:$BACKSRV_2_IP" >> "$TMP_FILE"

#-------------------#
# Backend Server #3 #
#-------------------#
echo "BACKSRV_3_IP:$BACKSRV_3_IP" >> "$TMP_FILE"

oci os object put \
     --bucket-name "$BUCKET_NAME" \
     --file "$TMP_FILE" \
     --content-type "text/plain" \
     --force \
     --name "$OBJECT_FILE_NAME" \
     --verify-checksum

rm -f "$TMP_FILE"