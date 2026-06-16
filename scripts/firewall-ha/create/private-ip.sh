#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/compute.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_id="$(get_subnet_id "$SUBNPRV_NAME" "$vcn_id" "$SUBNPRV_CIDR")"

# Reserva IPs privado na sub-rede
for i in $(seq $SECONDARY_IP_START $SECONDARY_IP_END); do
    ip="10.100.0.${i}"

    oci network private-ip create \
        --display-name "private-ip-${i}" \
        --ip-address "$ip" \
        --subnet-id "$vcn_subnprv_id" \
        --lifetime "RESERVED"    

    if [ $? -ne 0 ]; then
        echo "Error..."
        exit 1
    fi    
done