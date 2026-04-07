# Roteamento via Firewall Central (hub & spoke)

## Topologia Hub & Spoke

A topologia do tipo **Hub & Spoke** é muito utilizada em ambientes corporativos, nos quais há, geralmente, a necessidade de um firewall mais sofisticado (VCN Hub), capaz de oferecer maior controle e proteção sobre o tráfego entre aplicações (VCNs Spoke), sejam entre VCNs ou no fluxo de dados entre o ambiente on-premises e o OCI. 

De forma simples, a ideia geral é: **forçar, de forma transparente, que todo o tráfego entre aplicações passe por um firewall central.**

Para ilustrar o funcionamento dessa topologia, será utilizado o diagrama abaixo:

![Hub & Spoke #1](img/hub-spoke-1.png)

### Tabelas de Rotas

Falando das tabelas de roteamento, temos as que seguem:

- **Subnet Route Table**
    - Cada sub-rede tem a sua própria tabela de roteamento sendo que, há somente uma regra de roteamento no qual direciona todo o tráfego para o DRG (0.0.0.0/0).

- **DRG Route Table**
    - Há duas tabelas de roteamento do DRG que são:
        - **TO-FIREWALL**
            - Usada para direcionar todo o tráfego ao anexo do firewall (DRG‑ATTCH_VCN‑FIREWALL). 
            - A tabela contém apenas uma rota estática e deve ser aplicada a todos os anexos cujo tráfego precise obrigatoriamente passar pelo firewall.
        - **FROM-FIREWALL**
            - Utilizada pelo anexo do firewall e consultada no retorno do tráfego para a rede. Ou seja, quando o firewall envia a resposta. 
            - As rotas dessa tabela são inseridas automaticamente via instrução **Match All** do **Import Route Distribution** desta tabela, pois o firewall conhece e aprende todas as redes.

- **VCN Route Table**
    - Apenas do nome fazer referência a VCN, trata‑se de uma tabela de sub‑rede configurada no anexo do firewall. 
    - Esta tabela desempenha a função de **_ingress routing_** e é consultada assim que o tráfego entra na VCN-FIREWALL, no qual possui apenas uma regra estática cujo next‑hop aponta para o endereço IP do firewall (192.168.100.50).

### Fluxo de Roteamento

Suponha que a compute instance 10.100.20.5 da VCN-A (Spoke) queira se comunicar com o compute instance 172.16.50.100 da VCN-B (Spoke). As decisões de roteamento da origem para o destino, que fazem o tráfego passar pelo firewall 192.168.100.50 na VCN‑FIREWALL (Hub), são:

1. A primeira decisão de roteamento ocorre no próprio host (10.100.20.5). Nessa etapa o host determina o endereço IP e a interface de rede que será usada para enviar o tráfego. Normalmente existe uma **rota default** apontando para o gateway da sub‑rede (10.100.20.1).

2. A segunda decisão de roteamento ocorre no gateway da sub‑rede (10.100.20.1). O gateway consulta sua própria tabela de rotas para determinar o next‑hop (tabela de rotas da sub-rede). No exemplo, tudo deve ser encaminhado para o DRG (0.0.0.0/0).

3. A terceira decisão de roteamento ocorre quando o tráfego entra no DRG, que consulta a tabela de rotas **TO‑FIREWALL** para determinar o qual é o próximo anexo a seguir. Esta tabela contém uma regra estática que encaminha todo o tráfego (0.0.0.0/0) para o anexo **DRG-ATTCH_VCN-FIREWALL**, onde está a VCN‑FIREWALL e o compute instance do firewall (192.168.100.50).

4. A quarta decisão de roteamento ocorre quando o tráfego sai do DRG e passa a entrar na VCN-FIREWALL. O anexo **DRG-ATTCH_VCN-FIREWALL** possui uma tabela de rotas de sub-rede chamada **TO-FIREWALL-IP**, que contém uma única rota estática (0.0.0.0/0) que encaminha todo o tráfego para o endereço IP do firewall 192.168.100.50.

5. Na quinta etapa o tráfego atinge o compute instance firewall (192.168.100.50), que realiza a inspeção e, caso permita a passagem, consulta sua tabela de rotas do host para devolver o tráfego para o DRG. Normalmente há uma **rota default** apontando para o gateway da sub‑rede (192.168.100.1).

6. A sexta decisão de roteamento ocorre no gateway da sub‑rede (192.168.100.1). A tabela de rotas da sub‑rede contém as rotas para as redes da VCN‑A e VCN‑B (ambas apontando para o DRG) e uma **rota default** que permite ao firewall acessar a Internet via **NAT Gateway**.

7. Na sétima etapa o tráfego sai da VCN‑FIREWALL e, ao entrar no DRG, a tabela **FROM‑FIREWALL** é consultada. Essa tabela contém apenas rotas dinâmicas importadas automaticamente pela **Import Route Distribution** através da instrução **Match All**, de forma que ela passa a conhecer todas as redes conectadas ao DRG.

8. Por fim, o tráfego sai do DRG e chega à instância de destino 172.16.50.100.

O tráfego de retorno, ou seja, a resposta da instância 172.16.50.100 para 10.100.20.5, segue o mesmo fluxo de decisões de roteamento descrito anteriormente, em sentido inverso.

## Comandos de Exemplo

### DRG (Dynamic Routing Gateway)

```bash
$ oci network drg create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaa" \
> --display-name "drg"
```

### Anexo DRG (attachment)

#### VCN-FIREWALL

```bash
$ oci network drg-attachment create \
> --drg-id "ocid1.drg.oc1.sa-saopaulo-1.aaaaaaaa" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.amaaaaaa" \
> --display-name "DRG-ATTCH_VCN-FIREWALL"
```

### Import Route Distribution

#### IMPRT-TO-FIREWALL

```bash
$ oci network drg-route-distribution create \
> --drg-id "ocid1.drg.oc1.sa-saopaulo-1.aaaaaaaa" \
> --distribution-type "IMPORT" \
> --display-name "IMPRT-TO-FIREWALL"
```

#### IMPRT-FROM-FIREWALL

```bash
$ oci network drg-route-distribution create \
> --drg-id "ocid1.drg.oc1.sa-saopaulo-1.aaaaaaaa" \
> --distribution-type "IMPORT" \
> --display-name "IMPRT-FROM-FIREWALL"
```

### DRG Route Table

#### TO-FIREWALL

```bash
$ oci network drg-route-table create \
> --drg-id "ocid1.drg.oc1.sa-saopaulo-1.aaaaaaaa" \
> --display-name "TO-FIREWALL" \
> --import-route-distribution-id "ocid1.drgroutedistribution.oc1.sa-saopaulo-1.aaaaaaaa" \
> --is-ecmp-enabled "false"
```

```bash
$ oci network drg-route-rule add \
> --drg-route-table-id "ocid1.drgroutetable.oc1.sa-saopaulo-1.aaaaaaaa" \
> --route-rules '[{
>     "destination": "0.0.0.0/0",
>     "destinationType": "CIDR_BLOCK",
>     "nextHopDrgAttachmentId": "ocid1.drgattachment.oc1.sa-saopaulo-1.aaaaaaaaa"
> }]'
```

#### FROM-FIREWALL

```bash
$ oci network drg-route-table create \
> --drg-id "ocid1.drg.oc1.sa-saopaulo-1.aaaaaaaa" \
> --display-name "FROM-FIREWALL" \
> --import-route-distribution-id "ocid1.drgroutedistribution.oc1.sa-saopaulo-1.aaaaaaaa" \
> --is-ecmp-enabled "false"
```

```bash
$ oci network drg-route-distribution-statement add \
> --route-distribution-id "ocid1.drgroutedistribution.oc1.sa-saopaulo-1.aaaaaaaa" \
> --statements '[{
>     "action": "ACCEPT",
>     "matchCriteria": [{"matchType": "DRG_ATTACHMENT_TYPE", "attachmentType": "VCN"}],
>     "priority": 1
> }]'
```

### VCN Route Table

#### TO-FIREWALL-IP

O comando abaixo cria, na VCN‑FIREWALL, uma tabela de rotas com uma única regra que direciona todo o tráfego (0.0.0.0/0) para o IP do firewall (192.168.100.50). Para destinos que sejam endereços IP privados, utilize o OCID do endereço IP em vez do valor literal.

```bash
$ oci network route-table create \
> --compartment-id "ocid1.compartment.oc1..aaaaaaaa" \
> --vcn-id "ocid1.vcn.oc1.sa-saopaulo-1.amaaaaaa" \
> --display-name "TO-FIREWALL-IP" \
> --route-rules '[{
>     "destination": "0.0.0.0/0",
>     "destinationType": "CIDR_BLOCK",
>     "networkEntityId": "ocid1.privateip.oc1.sa-saopaulo-1.amaaaaaa"
> }]'
```

Após a criação, deve-se atualizar o anexo que conecta a VCN‑FIREWALL ao DRG com a tabela de rotas TO-FIREWALL-IP que foi criada:

```bash
$ oci network drg-attachment update \
> --drg-attachment-id "ocid1.drgattachment.oc1.sa-saopaulo-1.aaaaaaaaa" \
> --display-name "TO-FIREWALL" \
> --drg-route-table-id "ocid1.drgroutetable.oc1.sa-saopaulo-1.aaaaaaaa" \
> --route-table-id "ocid1.routetable.oc1.sa-saopaulo-1.aaaaaaaa" \
> --force 
```