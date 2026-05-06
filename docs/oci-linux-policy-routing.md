# OCI + Linux Policy Routing

## Roteamento por Destino

Por padrão, um roteador toma decisões de roteamento lendo o campo **Destination Address** do cabeçalho IP (e em teoria, mas não na prática, no campo TOS). Após obter o endereço IP presente no **Destination Address**, o próximo passo é consultar a tabela de rotas (**route table**), para determinar qual será a **interface de rede de saída** que será usada para **encaminhar o pacote**. Em outras palavras, a decisão de roteamento é baseada exclusivamente no **endereço de destino**, processo que também é chamado de **Roteamento por Destino (destination-based routing)**.

Para facilitar, imagine que duas instâncias queiram se comunicar, cada uma em redes diferentes, e que exista um roteador Linux no meio interligando essas redes.

![OCI Linux RT #1](/docs/img/oci-linux-rtb-1.png)

O fluxo de dados ocorre da seguinte maneira:

1. O **Compute Instance A (10.70.10.30)** - **origem** - quer comunicar-se com o **Compute Instance B (10.90.20.80)** - **destino**. Para isso, ele gera um pacote IP cujo cabeçalho contém os campos **Source Address** e **Destination Address** preenchidos com os respectivos endereços IP de origem e destino.

2. **Compute Instance A (10.70.10.30)** não sabe alcançar nenhum host da rede **10.90.20.0/24**, mas conhece o roteador pois, ambos estão na mesma rede **10.70.10.0/24** (diretamente conectados). Assim, o pacote é enviado ao roteador Linux **10.70.10.1**.

3. Após o pacote entrar pela interface de rede do roteador (**eth0**), inicia-se a **decisão de roteamento** que, basicamente, ocorre através da inspeção do campo **Destination Address** para determinar se o pacote deve ser entregue a um **processo local** (um daemon do próprio roteador) ou encaminhado para fora por outra interface de rede. 

4. Neste caso, o roteador determina que o pacote deve ser encaminhado para fora porque o endereço IP **10.90.20.80** contido no campo **Destination Address** pertence a outro host e não a ele mesmo. Em seguida, é consultada a tabela de rotas para descobrir qual interface deve ser usada para enviar o pacote. Essa decisão é feita por um cálculo que compara o **Destination Address** com os prefixos da tabela de rotas (aplicando as máscaras) e seleciona a rota mais específica (**longest-prefix match**).

5. O pacote sai então pela interface de rede selecionada no processo de roteamento (**eth1**) para então poder alcançar o **Compute Instance B (10.90.20.80)**.

Roteamento por destino não ocorre apenas em roteadores mas sim, em qualquer host da internet no qual utiliza TCP/IP para se comunicar. Todo host, antes de se comunicar com a rede, precisa consultar a sua própria tabela de rotas para determinar a interface de saída a ser usada, aplicando o mesmo princípio de comparação de prefixos (longest‑prefix match) ao campo **Destination Address**.

Um roteador difere de um host comum pela função de **encaminhar pacotes (forward)**. Ele recebe pacotes em uma interface e os encaminha para outra interface distinta.

Para ativar a função de encaminhamento no Linux, tornar o host um roteador, basta habilitar o parâmetro do kernel ```ip_forward```:

```bash
$ echo 1 > /proc/sys/net/ipv4/ip_forward
```

Se o roteador também encaminha pacotes IPv6, o parâmetro do kernel é outro: 

```bash
$ echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
```

## Policy Routing

**Policy Routing (ou Policy-Based Routing - PBR)** é uma técnica de roteamento em que a decisão de roteamento pode ser feita a partir de outros critérios além do endereço de destino. 

Muitas vezes, o **Policy Routing** é chamado de **roteamento inteligente** pois permite tomar decisões de roteamento com base não apenas no endereço de destino, mas também em outras propriedades dos pacotes, como endereço de origem, portas TCP/UDP, marcações em pacotes, campo TOS (Type of Service), interface de entrada, dados do pacote (payload), entre outros.

Normalmente, a configuração de **Policy Routing** divide‑se em duas etapas:

1. Criar várias tabelas de rotas.
2. Definir regras (policy rules) que escolhem, para cada pacote, qual tabela utilizar.

### Múltiplas Tabelas de Rotas

A funcionalidade de **Policy Routing**, presente no Linux desde o Kernel 2.2, permite criar e configurar múltiplas tabelas de rotas. Ao contrário do roteamento tradicional, que usa apenas uma tabela de rotas, o **Policy Routing** possibilita ter várias tabelas de roteamento independentes, cada uma contendo as suas próprias regras de roteamento (rotas).

Por padrão, o Linux vem configurado com **quatro tabelas de rotas** definidas no arquivo ```/etc/iproute2/rt_tables```:

```shell
$ cat /etc/iproute2/rt_tables
#
# reserved values
#
0       local
32766   main
32767   default
```

As tabelas são identificadas internamente pelo Kernel por IDs numéricos e, opcionalmente podem ser referenciadas por um respectivo nome. Para que um nome seja associado a um ID é preciso declará‑lo no arquivo ```/etc/iproute2/rt_tables``` pois, o Kernel lê esse arquivo na sua inicialização para reconhecer as tabelas nomeadas.

- **local (0)**
    - A tabela local contém rotas para endereços locais do sistema (local delivery), incluindo endereços broadcast, multicast e loopback.
    - Tem prioridade alta na decisão de roteamento onde, o Kernel consulta para determinar se um pacote é destinado ao próprio host.

- **main (32766)**
    - É a tabela de roteamento padrão usada pelo Linux no qual contém todas as rotas que não estão relacionadas com **Policy Routing**.

- **default (32767)**
    - Tabela reservada para processametno posterior quando não houver nenhuma combinação de regra presente na tabela **main**.

Em relação às tabelas pré‑configuradas, a tabela **main**, é, na prática, a única que se manipula manualmente quando não se utiliza **Policy Routing**, as demais devem ser deixadas para o Kernel gerenciar. 

Para visualizar o conteúdo de uma tabela é possível usar seu nome ou ID numérico:

```shell
$ ip route show table main
default via 10.90.20.254 dev eth1 proto kernel
10.70.10.0/24 dev eth0 proto kernel scope link src 10.70.10.1
10.90.20.0/24 dev eth1 proto kernel scope link src 10.90.20.1
```

O comando ```ip route show table main``` é equivalente ao comando ```route -n```, apenas com formato de saída diferente:

```shell
$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.90.20.254    0.0.0.0         UG    0      0        0 eth1
10.70.10.0      0.0.0.0         255.255.255.0   U     0      0        0 eth0
10.90.20.0      0.0.0.0         255.255.255.0   U     0      0        0 eth1
```

Para criar uma nova tabela, primeiro adicione seu ID e nome em ```/etc/iproute2/rt_tables```:

```shell
$ echo '100 internet' >> /etc/iproute2/rt_tables
```

Após isso, já se torna possível adicionar e manipular rotas nesta tabela:

```shell
$ ip route add 198.51.100.0/24 dev eth0 table internet
```

### ip rule

Além das tabelas, existe um conjunto de regras avaliadas antes da decisão de roteamento (isso faz parte do funcionamento padrão do Linux, independentemente do uso explícito de Policy Routing). Essas regras são manipuladas com o comando ```ip rule``` e, com base em critérios que você especifica, instruem o kernel sobre qual tabela de rotas deve ser consultada para efetuar a decisão de roteamento. Em resumo, as regras do ```ip rule``` são avaliadas antes das regras roteamento (tabela de rotas).

Por exemplo, a regra abaixo direciona a consulta para a tabela ```internet```, que será usada para determinar o next‑hop do pacote:

```shell
$ ip rule add to 8.8.8.8 table internet prio 10
```

Cada regra tem uma priordade de processamento onde, regras de maior prioridade (valor mais baixo) são avaliadas primeiro e seguem em ordem crescente até a última regra. Ao encontrar uma regra que dê match, sua ação é aplicada (por exemplo, consultar a tabela "internet") e as regras subsequentes não são avaliadas.

Por padrão, há as seguintes regras que fazem uso das tabelas ```local```, ```main``` e ```default```:

```shell
$ ip rule show
0:      from all lookup local
32766:  from all lookup main
32767:  from all lookup default
```

Por exemplo, a tabela ```local``` tem maior prioridade e será avaliada por primeiro. Como já foi dito, ela contém ontém rotas para endereços locais do sistema. Isso significa que, todo pacote (```from all```) obrigatóriamente entra na tabela ```local```.

```shell
$ ip route show table local
local 10.70.10.20 dev enp0s6 proto kernel scope host src 10.70.10.20 
broadcast 10.70.10.255 dev enp0s6 proto kernel scope link src 10.70.10.20 
local 10.80.30.40 dev enp1s0 proto kernel scope host src 10.80.30.40 
broadcast 10.80.30.255 dev enp1s0 proto kernel scope link src 10.80.30.40 
local 10.90.20.60 dev enp2s0 proto kernel scope host src 10.90.20.60 
broadcast 10.90.20.255 dev enp2s0 proto kernel scope link src 10.90.20.60 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 
```

## Netfilter

Além do ```ip rule``` e ```ip route```, existem outros estágios avaliados por regras que processam os pacotes. Em conjunto com o comando ```ip```, entram também as regras do _[Netfilter](https://en.wikipedia.org/wiki/Netfilter)_.

_[Netfilter](https://en.wikipedia.org/wiki/Netfilter)_ é um framework do Kernel Linux que expõe vários estágios de processamento que são consultados assim que um pacote entra pela interface de rede.

Os estágios do _[Netfilter](https://en.wikipedia.org/wiki/Netfilter)_ são divididos em dois componentes principais:

### tabelas

Existem três tabelas principais sendo que cada uma desempenha uma função específica:

- **FILTER**
    - Contém regras de filtragem de pacotes, usada para aceitar (ACCEPT), rejeitar (REJECT) ou descartar (DROP) tráfego.

- **NAT**
    - Contém regras de tradução de endereços/portas (DNAT, SNAT, MASQUERADE).

- **MANGLE**
    - Contém regras para alterações de cabeçalho e marcação de pacotes (p.ex. TOS/DSCP, TTL, marcação para routing/qos).

Para visualizar as regras de uma tabela específica, utilize o comando abaixo:

```shell
$ iptables -t filter -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```

### chains

Dentro de cada tabela existem os estágios de processamento ou chains que são:

- **INPUT**
    - Tratar pacotes destinados ao próprio host (local delivery). 
    - Ex.: um pacote direcionado a um processo ```nginx``` passa por este estágio.

- **FORWARD**
    - Processa pacotes que são encaminhados para fora do Linux, entram por uma interface e saem por outra.
    
- **OUTPUT**
    - Processa pacotes gerados localmente pelo host antes de serem enviados à rede.
    - Ex.: após atender uma requisição, o processo ```nginx``` gera um pacote de resposta que passa por essa chain antes de sair do host.

- **PREROUTING**
    - Processa pacotes assim que chegam, antes da decisão de roteamento.

- **POSTROUTING**
    - Processa pacotes após a decisão de roteamento.

Oficialmente, no contexto do Netfilter/iptables, o que eu chamo de **"estágio"** é chamado de **chain**, ou **cadeia** em português.

O termo **chain** faz sentido porque representa uma **cadeia de regras**, ou seja, é um conjunto de regras processadas sequencialmente, uma após a outra, afim de encontrar uma correspondência aos critérios que forão definidos. Quando uma correspondência é encontrada (deu match), a ação associada é executada sobre o pacote de dados.

Entretanto, nem todas as tabelas possuem as mesmas **chain** e, isso dependente da função que a tabela desempenha. 

Por exemplo, a tabela **FILTER** possui as chains **INPUT**, **FORWARD** e **OUTPUT**, pois sua função principal é filtrar pacotes que entram, saem ou são encaminhados para fora. Nesse caso, não faria sentido existir uma chain **PREROUTING** na tabela **FILTER**, pois essa etapa não tem relação com filtragem de pacotes.

Para as demais tabelas, **NAT** possui os estágios **PREROUTING**, **INPUT**, **OUTPUT** e **POSTROUTING**. E a tabela **MANGLE** possui os estágios **PREROUTING**, **INPUT**, **FORWARD**, **OUTPUT** e **POSTROUTING**.

O último detalhe está relacionado à **policy padrão da chain**, que define a ação aplicada quando nenhuma regra da cadeia corresponde aos critérios do pacote analisado.

Essa policy pode representar ações como **ACCEPT**, **REJECT** ou **DROP**:

- **ACCEPT**
    - O pacote é aceito e o seu processamento continua.

- **REJECT**
    - O pacote é rejeitado e uma resposta é enviada ao remetente (por padrão: ICMP ICMP Type 3, Code 3 / Destination Unreachable: Port Unreachable).

- **DROP**
    - O pacote é descartado e nenhuma resposta é enviada ao rementente. 

Por exemplo, para alterar a chain **INPUT** para **DROP** da tabela **FILTER**:

```shell
$ iptables -t filter -P INPUT DROP
```

Para criar uma regra que permita a entrada de pacotes destinados a um processo local escutando na porta 80/TCP, utilize o comando abaixo:

```shell
$ iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
```

Com essa regra, todo pacote que entra no host e tem como destino a porta 80/TCP será aceito. Qualquer outro pacote que não corresponda a essa regra será descartado pela **policy padrão DROP** que foi definida.

## Fluxo dos Pacotes dentro da Caixa

![OCI Linux PBR #1](/docs/img/oci-linux-pbr-1.png)

## Referências

- **Linux Advanced Routing & Traffic Control HOWTO**
    - https://lartc.org/howto/index.html

- **Linux netfilter Hacking HOWTO**
    - https://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO.html

- **IP Command Reference**
    - http://linux-ip.net/gl/ip-cref/

- **Policy Routing With Linux - Online Edition**
    - http://www.policyrouting.org/PolicyRoutingBook/ONLINE/TOC.html