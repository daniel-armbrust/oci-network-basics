# Descrição dos Componentes de Rede

## ```vcn-appl-1```

- Descrição: VCN para hospedagem de aplicações #1.
- IPv4 CIDR Prefixes: 10.50.0.0/16
- IPv6 CIDR Prefixes: fd91:ab42:1200::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - IPv4 CIDR Prefixes: 10.50.10.0/24
    - IPv6 CIDR Prefixes: fd91:ab42:1200:10::/64

## ```vcn-appl-2```

- Descrição: VCN para hospedagem de aplicações #2.
- IPv4 CIDR Prefixes: 10.60.0.0/16
- IPv6 CIDR Prefixes: fd55:77cc:8d00::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - IPv4 CIDR Prefixes: 10.60.10.0/24
    - IPv6 CIDR Prefixes: fd55:77cc:8d00:10::/64

## ```vcn-db```

- Descrição: VCN pública utilizada para tráfego de saída para a Internet.
- IPv4 CIDR Prefixes: 10.100.0.0/16
- IPv6 CIDR Prefixes: fd3f:9012:aa00::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - IPv4 CIDR Prefixes: 10.90.20.0/24
    - IPv6 CIDR Prefixes: fd3f:9012:aa00:10::/64

## ```vcn-publica```

- Descrição: VCN pública utilizada para tráfego de saída para a Internet.
- IPv4 CIDR Prefixes: 10.90.0.0/16
- IPv6 CIDR Prefixes: ** OCI GUA **

    ### ```subnpub-1```

    - Descrição: Sub-rede pública #1.
    - IPv4 CIDR Prefixes: 10.90.20.0/24
    - IPv6 CIDR Prefixes: ** OCI GUA **

## ```vcn-fw-interno```

- Descrição: VCN que abriga as VNICs do firewall e do Network Load Balancer interno, responsável pela inspeção do tráfego entre as VCNs de aplicação e o tráfego de saída para a Internet.
- IPv4 CIDR Prefixes: 10.70.0.0/16
- IPv6 CIDR Prefixes: fd82:44ee:f000::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - IPv4 CIDR Prefixes: 10.70.10.0/24
    - IPv6 CIDR Prefixes: fd82:44ee:f000:10::/64
