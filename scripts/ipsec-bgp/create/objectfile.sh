#!/bin/bash

source "../data.env"
source "../../lib/reserved_pub_ip.sh"
source "../../lib/vpn.sh"
source "../../lib/drg.sh"

TMP_FILE="$(mktemp)"
drg_id="$(get_drg_id "$DRG_NAME")"

#--------#
# VM-A-1 #
#--------#
vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"

#------------------#
# VPN Site-To-Site #
#------------------#
ipsec_id="$(get_ipsec_id "$VPN_NAME" "$drg_id")"

# Tunnel-1
ipsec_tunnel_1_id="$(get_ipsec_tunnel_1_id "$ipsec_id")"
ipsec_tunnel_1_ip="$(get_ipsec_tunnel_ip "$ipsec_id" "$ipsec_tunnel_1_id")"
ipsec_tunnel_1_psk="$(get_ipsec_tunnel_psk "$ipsec_id" "$ipsec_tunnel_1_id")"

# Tunnel-2
ipsec_tunnel_2_id="$(get_ipsec_tunnel_2_id "$ipsec_id")"
ipsec_tunnel_2_ip="$(get_ipsec_tunnel_ip "$ipsec_id" "$ipsec_tunnel_2_id")"
ipsec_tunnel_2_psk="$(get_ipsec_tunnel_psk "$ipsec_id" "$ipsec_tunnel_2_id")"

#-------------#
# Object File #
#-------------#
echo "$VM_A_1_HOSTNAME:$vm_a_1_pub_ip" >> $TMP_FILE

echo "BGP_ASN:$BGP_ASN" >> $TMP_FILE

echo "TUNNEL_1:$ipsec_tunnel_1_ip:$ipsec_tunnel_1_psk" >> $TMP_FILE
echo "TUNNEL_2:$ipsec_tunnel_2_ip:$ipsec_tunnel_2_psk" >> $TMP_FILE

echo "IPSEC_BGP_1_IP:$TUNNEL_1_ARMFW_IP_MASK:$TUNNEL_1_OCI_IP_MASK" >> $TMP_FILE
echo "IPSEC_BGP_2_IP:$TUNNEL_2_ARMFW_IP_MASK:$TUNNEL_2_OCI_IP_MASK" >> $TMP_FILE

oci os object put \
     --bucket-name "$BUCKET_NAME" \
     --file "$TMP_FILE" \
     --content-type "text/plain" \
     --force \
     --name "$OBJECT_FILE_NAME" \
     --verify-checksum

rm -f "$TMP_FILE"