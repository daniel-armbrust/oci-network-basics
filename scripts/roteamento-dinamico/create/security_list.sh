#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/reserved_pub_ip.sh"

#------------#
# Public IPs #
#------------#
vm_a_1_pub_ip="$(get_reserved_pub_ip "$VM_A_1_RPUBIP_NAME")"
vm_b_1_pub_ip="$(get_reserved_pub_ip "$VM_B_1_RPUBIP_NAME")"
vm_c_1_pub_ip="$(get_reserved_pub_ip "$VM_C_1_RPUBIP_NAME")"

#-------#
# VCN-A #
#-------#
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"

# VCN-A / SUBNPUB - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPUB_SECL_NAME" \
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
        \"source\": \"$vm_b_1_pub_ip/32\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$vm_c_1_pub_ip/32\"
    }]" \
    --wait-for-state "AVAILABLE"

# VCN-A / SUBNPRV - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_a_id" \
    --display-name "$VCN_A_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"

#-------#
# VCN-B #
#-------#
vcn_b_id="$(get_vcn_id "$VCN_B_NAME" "$VCN_B_CIDR")"

# VCN-B / SUBNPUB - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_SUBNPUB_SECL_NAME" \
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
        \"source\": \"$vm_b_1_pub_ip/32\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$vm_c_1_pub_ip/32\"
    }]" \
    --wait-for-state "AVAILABLE"

# VCN-B / SUBNPRV - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_b_id" \
    --display-name "$VCN_B_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"

#-------#
# VCN-C #
#-------#
vcn_c_id="$(get_vcn_id "$VCN_C_NAME" "$VCN_C_CIDR")"

# VCN-C / SUBNPUB - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_c_id" \
    --display-name "$VCN_C_SUBNPUB_SECL_NAME" \
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
        \"source\": \"$vm_b_1_pub_ip/32\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$vm_c_1_pub_ip/32\"
    }]" \
    --wait-for-state "AVAILABLE"

# VCN-C / SUBNPRV - Security List 
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_c_id" \
    --display-name "$VCN_C_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0"
    }]' \
    --wait-for-state "AVAILABLE"
