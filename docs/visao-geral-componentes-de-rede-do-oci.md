# Visão Geral dos Componentes de Rede do OCI

## Componentes Básicos

- [VCN](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/Overview_of_VCNs_and_Subnets.htm)
    - Rede privada virtual que você cria nos data centers da Oracle (software-defined network).

- [Sub-rede](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/Overview_of_VCNs_and_Subnets.htm)
    - É a subdivisão de uma VCN e pode ser pública ou privada.
        - Uma sub-rede pública permite receber tráfego direto da Internet (origem: Internet), desde que o recurso computacional tenha um endereço IP público associado.

- [Route Table](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingroutetables.htm)
    - Uma tabela de roteamento de sub-rede é composta por regras de roteamento e é utilizada pelos recursos computacionais da sub-rede sempre que precisam enviar tráfego "para fora" dela.

- [Security Lists](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/securityrules.htm)
    - Firewall Virtual para as camadas 3 e 4 do modelo OSI, com a funcionalidade de permitir o tráfego de entrada (ingress) e saída (egress) da sub-rede.
        - Somente é permitido adicionar regras que autorizam a passagem de tráfego (ALLOW). Se não houver uma regra que permita a passagem do tráfego, este será bloqueado por padrão (DENY).
        - As regras podem ser do tipo Stateful ou Stateless. As regras Stateless são recomendadas quando os recursos computacionais na sub-rede estiverem sujeitos a um alto volume de tráfego (high throughput).
        - É possível ter até seis Security Lists "empilhadas" em uma sub-rede. Cada Security List será avaliada em sequência na busca por uma regra que permita a passagem do tráfego.

- [DHCP Options](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDHCP.htm)
    - Serviço Dynamic Host Configuration Protocol (DHCP) para os recursos computacionais das sub-redes. 

## Gateways de Comunicação

- [Internet Gateway (IGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingIGs.htm)
    - Gateway que permite o acesso à Internet, tanto para entrada quanto para saída, dos recursos computacionais localizados em uma sub-rede pública (origem e destino: Internet).
 
- [NAT Gateway (NGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/NATgateway.htm)
    - Gateway que permite o acesso à Internet a partir dos recursos computacionais localizados em uma sub-rede privada (destino: Internet).

- [Service Gateway (SGW)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/servicegateway.htm)
    - Gateway que permite o acesso à rede de serviços da Oracle a partir de uma sub-rede privada, sem a necessidade de utilizar a Internet.

- [Dynamic Routing Gateway (DRG)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDRGs.htm)
    - Roteador virtual do OCI que permite a conexão e acesso a outras VCNs na mesma região ou em regiões diferentes, além de possibilitar o acesso ao On-Premises via FastConnect (link dedicado) ou VPN IPSec.

- [Local Peering Gateway (LPG)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/localVCNpeering.htm)
    - Gateway que permite a conexão entre duas VCNs.