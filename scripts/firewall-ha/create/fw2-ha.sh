#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/subnet.sh"
source "../../lib/compute.sh"

vcn_id="$(get_vcn_id "$VCN_NAME" "$VCN_CIDR")"
vcn_subnprv_id="$(get_subnet_id "$SUBNPRV_NAME" "$vcn_id" "$SUBNPRV_CIDR")"

fw_1_vnic_id="$(get_vnic_id "$FW_1_IP" "$vcn_subnprv_id")"
fw_2_vnic_id="$(get_vnic_id "$FW_2_IP" "$vcn_subnprv_id")"

# Obtém a lista de endereços IPs Privados da sub-rede, 
# excluindo os IPs primários dos firewalls. 
private_ips="$(
    oci network private-ip list \
            --all \
            --lifetime RESERVED \
            --subnet-id "$vcn_subnprv_id" \
            --query "data[?\"ip-address\"!='$FW_1_IP' && \"ip-address\"!='$FW_2_IP'].id" \
            --raw-output |
    tr -d '[]",' |
    sed '/^[[:space:]]*$/d' |
    sed 's/^[[:space:]]*//'
)"

# Converte para array
mapfile -t ips <<< "$private_ips"

# https://docs.oracle.com/en-us/iaas/api/#/en/iaas/20160918/datatypes/BulkDetachPrivateIpsDetails
# Max Items: 16
BATCH_SIZE=16

for ((i=0; i<${#ips[@]}; i+=BATCH_SIZE)); do
    detach_json='['
    update_json='['

    for ((j=i; j<i+BATCH_SIZE && j<${#ips[@]}; j++)); do
        [ $j -gt $i ] && {
            detach_json+=','
            update_json+=','
        }

        detach_json+="{\"privateIpId\":\"${ips[$j]}\"}"
        update_json+="{\"privateIpId\":\"${ips[$j]}\",\"lifetime\":\"RESERVED\"}"
    done

    detach_json+=']'
    update_json+=']'

    #
    # FW1 - Remove da VNIC atual
    #
    oci network private-ip bulk-detach \
        --vnic-id "$fw_1_vnic_id" \
        --bulk-detach-private-ip-item "$detach_json" \
        --wait-for-state "SUCCEEDED"
    
    if [ $? -ne 0 ]; then
        echo "Error..."
        exit 1
    fi    

    #
    # FW2 - Atribui à nova VNIC mantendo RESERVED
    #
    oci network private-ip bulk-update \
        --vnic-id "$fw_2_vnic_id" \
        --bulk-update-private-ip-item "$update_json" \
        --wait-for-state "SUCCEEDED"
    
    if [ $? -ne 0 ]; then
        echo "Error..."
        exit 1
    fi    
done