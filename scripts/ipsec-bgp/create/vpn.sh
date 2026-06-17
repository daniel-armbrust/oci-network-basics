#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/vpn.sh"
source "../../lib/drg.sh"
source "../../lib/reserved_pub_ip.sh"
source "../../lib/compute.sh"

vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"

oci network cpe create \
    --compartment-id "$COMPARTMENT_ID" \
    --ip-address "$vm_a_1_pub_ip" \
    --display-name "$CPE_NAME"

cpe_id="$(get_cpe_id "$CPE_NAME")"
drg_id="$(get_drg_id "$DRG_NAME")"

vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_subnpub_id="$(get_subnet_id "$VCN_A_SUBNPUB_NAME" "$vcn_a_id" "$VCN_A_SUBNPUB_CIDR")"

vm_a_1_vnic_id="$(get_vnic_id "$VM_A_1_IP" "$vcn_a_subnpub_id")"
vm_a_1_instance_id="$(get_instance_id "$vm_a_1_vnic_id")"
vm_a_1_private_ip="$(get_private_ip "$vm_a_1_instance_id")"

oci network ip-sec-connection create \
    --compartment-id "$COMPARTMENT_ID" \
    --cpe-id "$cpe_id" \
    --drg-id "$drg_id" \
    --cpe-local-identifier "$vm_a_1_private_ip" \
    --cpe-local-identifier-type "IP_ADDRESS" \
    --display-name "$VPN_NAME" \
    --static-routes '[]' \
    --tunnel-configuration "[
        {
           \"displayName\":\"tunnel-1\",
           \"ikeVersion\":\"V2\",
           \"routing\":\"BGP\",
           \"bgpSessionConfig\":{
                \"customerBgpAsn\":$BGP_ASN,
                \"customerInterfaceIp\":\"$TUNNEL_1_ARMFW_IP_MASK\",
                \"oracleInterfaceIp\":\"$TUNNEL_1_OCI_IP_MASK\"
            }
        },
        {
           \"displayName\":\"tunnel-2\",
           \"ikeVersion\":\"V2\",
           \"routing\":\"BGP\",
           \"bgpSessionConfig\":{
                \"customerBgpAsn\":$BGP_ASN,
                \"customerInterfaceIp\":\"$TUNNEL_2_ARMFW_IP_MASK\",
                \"oracleInterfaceIp\":\"$TUNNEL_2_OCI_IP_MASK\"
            }
        }
    ]" \
    --wait-for-state "AVAILABLE"