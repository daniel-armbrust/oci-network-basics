# Componentes de Rede da Topologia de Referência

## ```vcn-appl-1```

- Descrição: VCN para hospedagem de aplicações #1.
- Prefixo(s) CIDR IPv4: 10.50.0.0/16
- Prefixo(s) CIDR IPv6: fd91:ab42:1200::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - Prefixo(s) CIDR IPv4: 10.50.10.0/24
    - Prefixo(s) CIDR IPv6: fd91:ab42:1200:10::/64

    ### ```rt_subnprv-1```

    - Descrição: Tabela de Roteamento da Sub-rede privada #1.

    ### ```secl-1_subnprv-1```

    - Descrição: Security List #1 da Sub-rede privada #1.

    ### ```dhcp-options```

    - Descrição: DHCP Options da VCN para hospedagem de aplicações #1.
    
## ```vcn-appl-2```

- Descrição: VCN para hospedagem de aplicações #2.
- Prefixo(s) CIDR IPv4: 10.60.0.0/16
- Prefixo(s) CIDR IPv6: fd55:77cc:8d00::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - Prefixo(s) CIDR IPv4: 10.60.10.0/24
    - Prefixo(s) CIDR IPv6: fd55:77cc:8d00:10::/64

    ### ```rt_subnprv-1```

    - Descrição: Tabela de Roteamento da Sub-rede privada #1.

    ### ```secl-1_subnprv-1```

    - Descrição: Security List #1 da Sub-rede privada #1.

    ### ```dhcp-options```

    - Descrição: DHCP Options da VCN para hospedagem de aplicações #2.

## ```vcn-db```

- Descrição: VCN para hospedagem hospedagem dos Bancos de Dados.
- Prefixo(s) CIDR IPv4: 10.100.0.0/16
- Prefixo(s) CIDR IPv6: fd3f:9012:aa00::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - Prefixo(s) CIDR IPv4: 10.90.20.0/24
    - Prefixo(s) CIDR IPv6: fd3f:9012:aa00:10::/64

    ### ```rt_subnprv-1```

    - Descrição: Tabela de Roteamento da Sub-rede privada #1.

    ### ```secl-1_subnprv-1```

    - Descrição: Security List #1 da Sub-rede privada #1.

    ### ```dhcp-options```

    - Descrição: DHCP Options da VCN para hospedagem dos Bancos de Dados.

## ```vcn-publica```

- Descrição: VCN utilizada para tráfego de saída para a Internet.
- Prefixo(s) CIDR IPv4: 10.90.0.0/16
- Prefixo(s) CIDR IPv6: ** OCI GUA **

    ### ```subnpub-1```

    - Descrição: Sub-rede pública #1.
    - Prefixo(s) CIDR IPv4: 10.90.20.0/24
    - Prefixo(s) CIDR IPv6: ** OCI GUA **

    ### ```rt_subnpub-1```

    - Descrição: Tabela de Roteamento da Sub-rede pública #1.

    ### ```secl-1_subnpub-1```

    - Descrição: Security List #1 da Sub-rede pública #1.

    ### ```dhcp-options```

    - Descrição: DHCP Options da VCN para tráfego de saída para a Internet.

## ```vcn-fw-interno```

- Descrição: VCN que hospeda as VNICs do firewall e do Network Load Balancer interno, responsável pela inspeção do tráfego entre as VCNs de aplicação e o tráfego de saída para a Internet.
- Prefixo(s) CIDR IPv4: 10.70.0.0/16
- Prefixo(s) CIDR IPv6: fd82:44ee:f000::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - Prefixo(s) CIDR IPv4: 10.70.10.0/24
    - Prefixo(s) CIDR IPv6: fd82:44ee:f000:10::/64

## ```vcn-fw-externo```

- Descrição: VCN que hospeda as VNICs do firewall e do Network Load Balancer externo, responsável pela inspeção do tráfego que vem do on-premises com destino as redes do OCI.
- Prefixo(s) CIDR IPv4: 10.80.0.0/16
- Prefixo(s) CIDR IPv6: fd60:1a2b:9900::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - Prefixo(s) CIDR IPv4: 10.80.30.0/24
    - Prefixo(s) CIDR IPv6: fd60:1a2b:9900:10::/64

## ```vcn-onpremises```

- Descrição: VCN que simula o ambiente on-premises e se conecta ao DRG do OCI através de IPSec.
- Prefixo(s) CIDR IPv4: 172.16.100.0/24, 10.200.10.0/24, 192.168.100.0/24
- Prefixo(s) CIDR IPv6: 

    ### ```subnpub-internet```

    - Descrição: Sub-rede pública.
    - Prefixo(s) CIDR IPv4: 172.16.100.0/25
    - Prefixo(s) CIDR IPv6: 

    ### ```subnprv-rede-app```

    - Descrição: Sub-rede que hospeda as aplicações do ambiente on-premises.
    - Prefixo(s) CIDR IPv4: 10.200.10.128/26
    - Prefixo(s) CIDR IPv6: 

    ### ```subnprv-rede-backup```

    - Descrição: Sub-rede responsável pela execução de processos de backup a partir do ambiente on-premises.
    - Prefixo(s) CIDR IPv4: 192.168.100.64/26
    - Prefixo(s) CIDR IPv6: 