#!/bin/bash

get_vnic_id() {
    local ip="$1"
    local subnet_id="$2"

    oci network private-ip list \
        --ip-address "$ip" \
        --subnet-id "$subnet_id" \
        --query 'data[0]."vnic-id"' \
        --raw-output
}

get_private_ip_id() {
    local vnic_id="$1"

    oci network private-ip list \
        --vnic-id "$vnic_id" \
        --all \
        --query 'data[0].id' \
        --raw-output
}

get_instance_id() {
    # Retorna o instance_id a partir do vnic_id
    local vnic_id="$1"

    oci compute vnic-attachment list \
        --compartment-id "$COMPARTMENT_ID" \
        --all \
        --query "data[?\"vnic-id\"=='$vnic_id'].\"instance-id\" | [0]" \
        --raw-output
}