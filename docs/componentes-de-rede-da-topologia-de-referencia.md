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

    ### ```lpg_vcn-appl-1_vcn-db```

    - Descrição: Local Peering Gateway que conecta a ```vcn-appl-1``` à ```vcn-db```.
    
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

    ### ```lpg_vcn-appl-2_vcn-db```

    - Descrição: Local Peering Gateway que conecta a ```vcn-appl-2``` à ```vcn-db```.

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

    ### ```lpg_vcn-db_vcn-appl-1```

    - Descrição: Local Peering Gateway que conecta a ```vcn-db``` à ```vcn-appl-1```.

    ### ```lpg_vcn-db_vcn-appl-2```

    - Descrição: Local Peering Gateway que conecta a ```vcn-db``` à ```vcn-appl-2```.

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

- Descrição: VCN que hospeda as VNICs do firewall e do Network Load Balancer interno (```nlb_fw-interno```), responsável pela inspeção do tráfego entre as VCNs de aplicação e o tráfego de saída para a Internet.
- Prefixo(s) CIDR IPv4: 10.70.0.0/16
- Prefixo(s) CIDR IPv6: fd82:44ee:f000::/48

    ### ```subnprv-1```

    - Descrição: Sub-rede privada #1.
    - Prefixo(s) CIDR IPv4: 10.70.10.0/24
    - Prefixo(s) CIDR IPv6: fd82:44ee:f000:10::/64

## ```vcn-fw-externo```

- Descrição: VCN que hospeda as VNICs do firewall e do Network Load Balancer externo (```nlb_fw-externo```), responsável pela inspeção do tráfego que vem do on-premises com destino as redes do OCI.
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

## ```drg-externo```

- Descrição: DRG Externo cuja função é conectar a rede On-Premises ao OCI via IPSec. Este DRG direciona o tráfego com origem do on-premises para a ```vcn-appl-2``` (10.60.0.0/16, fd55:77cc:8d00::/48), onde será inspecionado pelo firewall. Além disso, este DRG se conecta ao ```drg-interno``` por meio de uma Remote Peering Connection (```rpc_drg-interno```), permitindo o acesso do on-premises à ```vcn-appl-1``` (tráfego com destino a ```vcn-appl-1``` não é inspecionado pelo firewall).

## ```drg-interno```

- Descrição: DRG Interno cuja função é possibilitar a conexão leste-oeste entre as VCNs de Aplicação (```vcn-appl-1``` e ```vcn-appl-2```). Este DRG direciona o tráfego para inspeção pelo firewall, tanto para acesso à Internet (outbound) quanto quando a ```vcn-appl-2``` precisa se comunicar com o On-premises.

## ```onpremises_ipsec```

- Descrição: Site-To-Site VPN para a conexão com o ambiente On-Premises.

    ### ```cpe_vm-ipsec_onpremises```

    - Descrição: CPE (Customer Premises Equipament) no qual representa o endereço IP público da VPN no ambiente On-Premises.

    ### ```tunnel-1``` e ```tunnel-2```

    - Descrição: Túneis IPSec redundantes para a conexão com o ambiente On-Premises.

## ```nlb_fw-interno```

- Descrição: que distribui o tráfego que vem da ```vcn-appl-2``` com destino ao ambiente On-Premises e à Internet (outbound) para as VNICs dos firewalls (```firewall-1``` e ```firewall-2```). Este componente de rede garante a alta disponibilidade dos firewalls no ambiente OCI.
- Endereço IPv4 do Listener: 10.70.10.100
- Endereço IPv6 do Listener: fd82:44ee:f000:10::100

## ```nlb_fw-externo```

- Descrição: Network Load Balancer que distribui o tráfego que vem do ambiente On-Premises para as VNICs dos firewalls (```firewall-1``` e ```firewall-2```). Este componente de rede assegura a alta disponibilidade dos firewalls no ambiente OCI.
- Endereço IPv4 do Listener: 10.80.30.100
- Endereço IPv6 do Listener: fd82:44ee:f000:10::100

## ```firewall-1``` e ```firewall-2```

- Descrição: VM Firewall com três VNICs.

    ### ```vnic-appl```

    - Descrição: VNIC do Firewall responsável por receber e inspecionar o tráfego que vem da ```vcn-appl-2``` e direcionado à Internet (outbound) a partir de ambas as VCNs (```vcn-appl-1``` e ```vcn-appl-2```).
    - Endereço IPv4 do ```firewall-1```: 10.70.10.20
    - Endereço IPv6 do ```firewall-1```: fd82:44ee:f000:10::20
    - Endereço IPv4 do ```firewall-2```: 10.70.10.21
    - Endereço IPv6 do ```firewall-2```: fd82:44ee:f000:10::21

    ### ```vnic-externo```

    - Descrição: VNIC do Firewall responsável por receber e inspecionar o tráfego que vem do On-Premises com destino à ```vcn-appl-2```.
    - Endereço IPv4 do ```firewall-1```: 10.80.30.40
    - Endereço IPv6 do ```firewall-1```: fd60:1a2b:9900:10::40
    - Endereço IPv4 do ```firewall-2```: 10.80.30.41
    - Endereço IPv6 do ```firewall-2```: fd60:1a2b:9900:10::41

    ### ```vnic-internet```

    - Descrição: VNIC do Firewall responsável por receber e inspecionar o tráfego proveniente das VCNs ```vcn-appl-1``` e ```vcn-appl-2```, com destino à Internet.
    - Endereço IPv4 do ```firewall-1```: 10.90.20.60
    - Endereço IPv6 do ```firewall-1```: ** OCI GUA **
    - Endereço IPv4 do ```firewall-2```: 10.90.20.80
    - Endereço IPv6 do ```firewall-2```: ** OCI GUA **