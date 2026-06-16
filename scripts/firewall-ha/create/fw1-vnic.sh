#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/compute.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_id="$(get_subnet_id "$SUBNPRV_NAME" "$vcn_id" "$SUBNPRV_CIDR")"

fw_1_vnic_id="$(get_vnic_id "$FW_1_IP" "$vcn_subnprv_id")"

# Obtém a lista de endereços IPs Privados da sub-rede, 
# excluindo os IPs primários dos firewalls. 
private_ips="$(oci network private-ip list \
    --all \
    --lifetime "RESERVED" \
    --subnet-id "$vcn_subnprv_id" \
    --query "data[?\"ip-address\"!='$FW_1_IP' && \"ip-address\"!='$FW_2_IP'].\"ip-address\"" \
    --raw-output | tr -d '[]",' | sed 's/^ *//')"

# Atribui um IP por vez ao FW1
count=1
while read -r private_ip; do
    if [ -z "$private_ip" ]; then
        continue
    fi

    oci network vnic assign-private-ip \
        --display-name "ip-$count" \
        --ip-address "$private_ip" \
        --lifetime "RESERVED" \
        --vnic-id "$fw_1_vnic_id" \
        --hostname-label "ip$count" \
        --unassign-if-already-assigned

    count=$((count + 1))
done <<< "$private_ips"