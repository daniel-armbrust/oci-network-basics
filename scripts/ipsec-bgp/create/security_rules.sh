#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/drg.sh"
source "../../lib/vpn.sh"
source "../../lib/security_list.sh"
source "../../lib/reserved_pub_ip.sh"

vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnpub_secl_id="$(get_secl_id "$VCN_A_SUBNPUB_SECL_NAME" "$vcn_a_id")"

#------------#
# Public IPs #
#------------#
vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"
my_pub_ip="$(curl -s ifconfig.me 2>/dev/null)/32"

# VPN Site-To-Site
drg_id="$(get_drg_id "$DRG_NAME")"
ipsec_id="$(get_ipsec_id "$VPN_NAME" "$drg_id")"

# Tunnel-1
ipsec_tunnel_1_id="$(get_ipsec_tunnel_1_id "$ipsec_id")"
ipsec_tunnel_1_ip="$(get_ipsec_tunnel_ip "$ipsec_id" "$ipsec_tunnel_1_id")"

# Tunnel-2
ipsec_tunnel_2_id="$(get_ipsec_tunnel_2_id "$ipsec_id")"
ipsec_tunnel_2_ip="$(get_ipsec_tunnel_ip "$ipsec_id" "$ipsec_tunnel_2_id")"

oci network security-list update \
    --security-list-id "$vcn_a_subnpub_secl_id" \
    --display-name "$VCN_A_SUBNPUB_SECL_NAME" \
    --force \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules "[{
        \"protocol\": \"all\",
        \"source\": \"$vm_a_1_pub_ip/32\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$my_pub_ip\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$ipsec_tunnel_1_ip/32\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$ipsec_tunnel_2_ip/32\"
    }]" \
    --wait-for-state "AVAILABLE"