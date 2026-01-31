#!/bin/bash

pub_ip_id="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/pub-ip-id`"
pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/pub-ip`"

internet_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-ip`"
internet_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-ip-gw`"
internet_iface="`ip -o -f inet addr show | grep "$internet_ip" | awk '{print $2}'`"

rede_app_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-app-ip`"
rede_app_ip_gw="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-app-ip-gw`"
rede_app_iface="`ip -o -f inet addr show | grep "$rede_app_ip" | awk '{print $2}'`"

instance_id="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance | grep '"id":' | awk '{print $2}' | tr -d '":, '`"
vnic_id="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/vnics | grep '"vnicId":' | awk '{print $2}' | tr -d '":, ' | head -1`"
vnic_private_ip_id="`oci --auth instance_principal network private-ip list --all --vnic-id $vnic_id --raw-output --query 'data[].id' | tr -d '[]" \n'`"
vnic_public_ip_id="`oci --auth instance_principal network public-ip get --private-ip-id $vnic_private_ip_id --query 'data.id' | tr -d '[]" \n'`"

# Endereço IP já foi trocado.
if [ "$pub_ip_id" == "$vnic_public_ip_id" ]; then
    exit 0
fi

# Altera temporariamente a rota padrão devido à remoção do IP Público Efêmero da interface 
# primária.
ip route del default dev $internet_iface
ip route add default via $rede_app_ip_gw dev $rede_app_iface

# Exclui o Endereço IP Público da VNIC primária.
# NOTA: Essa operação é necessária para permitir a adição do Endereço IP Público Reservado à VNIC.
oci --auth instance_principal network public-ip delete --public-ip-id $vnic_public_ip_id --force

# Atribui o Endereço IP Público Reservado à VNIC primária.
oci --auth instance_principal network public-ip update --public-ip-id $pub_ip_id --private-ip-id $vnic_private_ip_id --force

# Altera a Rota Default para utilizar a rede da Internet.
ip route del default dev $rede_app_iface
ip route add default via $internet_ip_gw dev $internet_iface

exit 0