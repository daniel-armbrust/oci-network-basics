#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"

#--------------#
# VCN-FRONTEND #
#--------------#
vcn_frontend_id="$(get_vcn_id "$VCN_FRONTEND_NAME" "$VCN_FRONTEND_CIDR")"
my_pub_ip="$(curl -s ifconfig.me 2>/dev/null)/32"

# Sub-rede Pública
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_frontend_id" \
    --display-name "$VCN_FRONTEND_SUBNPUB_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0"
    }]' \
    --ingress-security-rules "[{
        \"protocol\": \"all\",
        \"source\": \"$my_pub_ip\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$VCN_FRONTEND_CIDR\"
    },
    {
        \"protocol\": \"all\",
        \"source\": \"$VCN_BACKEND_CIDR\"
    },
    {
        \"protocol\": \"6\",
        \"source\": \"0.0.0.0/0\",
        \"tcpOptions\": {
            \"destinationPortRange\": {
                \"min\": 80,
                \"max\": 80
            }
        }
    },
    {
        \"protocol\": \"6\",
        \"source\": \"0.0.0.0/0\",
        \"tcpOptions\": {
            \"destinationPortRange\": {
                \"min\": 443,
                \"max\": 443
            }
        }
    },
    {
        \"protocol\": \"6\",
        \"source\": \"0.0.0.0/0\",
        \"tcpOptions\": {
            \"destinationPortRange\": {
                \"min\": 9001,
                \"max\": 9001
            }
        }
    },
    {
        \"protocol\": \"1\",
        \"source\": \"0.0.0.0/0\",
        \"icmpOptions\": {
            \"type\": 8
        }
    }]" \
    --wait-for-state "AVAILABLE"

#-------------#
# VCN-BACKEND #
#-------------#
vcn_backend_id="$(get_vcn_id "$VCN_BACKEND_NAME" "$VCN_BACKEND_CIDR")"

# Sub-rede Privada
oci network security-list create \
    --compartment-id "$COMPARTMENT_ID" \
    --vcn-id "$vcn_backend_id" \
    --display-name "$VCN_BACKEND_SUBNPRV_SECL_NAME" \
    --egress-security-rules '[{
        "protocol": "all",
        "destination": "0.0.0.0/0",
        "isStateless": true
    }]' \
    --ingress-security-rules '[{
        "protocol": "all",
        "source": "0.0.0.0/0",
        "isStateless": true
    }]' \
    --wait-for-state "AVAILABLE"