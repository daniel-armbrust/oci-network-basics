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
    - Apesar do nome fazer referência a VCN, trata‑se de uma tabela de sub‑rede configurada no anexo do firewall (DRG-ATTCH_VCN-FIREWALL). 
    - A tabela TO-FIREWALL-IP desempenha a função de **_ingress routing_** e é consultada assim que o tráfego entra na VCN-FIREWALL, no qual possui apenas uma regra estática cujo next‑hop aponta para o endereço IP do firewall (192.168.100.50).

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

No diretório `scripts/roteamento-via-firewall-central` há um conjunto de scripts para criar a topologia apresentada através do OCI CLI. 

```bash
$ ls -1F
create/
destroy/
lib/
network.env
```

O arquivo `network.env` define variáveis globais usadas pelos scripts. Elas specificam nomes dos recursos, endereços IP, IDs das imagens Linux, tipo de shape e quantidades de OCPU e memória.

Antes de executar os scripts, crie e exporte as seguintes variáveis de ambiente:

- **COMPARTMENT_ID**
    - ID do compartment onde os recursos serão criados no seu tenancy. 

- **SSH_PUB_KEY_PATH**
    - Caminho para a chave pública SSH que será usada pelas três compute instances (VM-A, VM-B e FIREWALL).

```bash
$ export COMPARTMENT_ID="ocid1.compartment.oc1..aaaaaaaa"
$ export SSH_PUB_KEY_PATH="/caminho/chave-publica-ssh.key"
```

Para criar os recursos, execute o script `create.sh` a partir do diretório `create/`:

```bash
$ cd create/
$ ./create.sh
```

Para excluir os recursos, execute o script `destroy.sh` a partir do diretório `destroy/`:

```bash
$ cd destroy/
$ ./destroy.sh
```