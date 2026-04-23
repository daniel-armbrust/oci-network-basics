#!/bin/bash

TMP_FILE="$(mktemp)"

# Obtém Mac Address, Endereço IPv4, Subnet IPv4 CIDR, 
# Endereço IPv6 (se houver) e Subnet IPv6 CIDR (se IPv6 existir). 
curl -s -H "Authorization: Bearer Oracle" -L \
http://169.254.169.254/opc/v2/vnics/ | \
jq -r '
.[] |
[
  .macAddr,
  .privateIp,
  .subnetCidrBlock,
  ((.ipv6Addresses // []) | join(",")),
  ((.ipv6SubnetCidrBlocks // []) | join(","))
]
| map(select(length > 0))
| join(" ")
' | tr -s "A-Z" "a-z" > "$TMP_FILE"

# O trecho do código abaixo só configura os IPs nas interfaces de rede. Não
# há configuração de roteamento aqui.
while IFS= read -r line; do
    file_mac="$(echo -n "$line" | cut -f1 -d ' ' | tr -d ' ')"
    iface="$(ip -o link | awk -v mac="$file_mac" -F': ' '$0 ~ mac {print $2}')"

    ipv4_addr="$(echo -n "$line" | cut -f2 -d ' ' | tr -d ' ')"
    ipv4_mask="$(echo -n "$line" | cut -f3 -d ' ' | cut -f2 -d '/' | tr -d ' ')"

    ipv6_addr="$(echo -n "$line" | cut -f4 -d ' ' | tr -d ' ')"
    ipv6_mask="$(echo -n "$line" | cut -f5 -d ' ' | cut -f2 -d '/' | tr -d ' ')"

    ip addr add "$ipv4_addr/$ipv4_mask" dev "$iface"

    if [ -n "$ipv6_addr" ] && [ -n "$ipv6_mask" ]; then
        ip -6 addr add "$ipv6_addr/$ipv6_mask" dev "$iface"
    fi

    ip link set "$iface" up
done < "$TMP_FILE"

rm -f "$TMP_FILE"

exit 0