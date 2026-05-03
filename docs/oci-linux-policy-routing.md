# OCI + Linux Policy Routing

## Roteamento por Destino

Por padrão, um roteador toma decisões de roteamento lendo o campo **Destination Address** do cabeçalho IP (IP Header). Após obter o endereço IP presente no **Destination Address**, o próximo passo é consultar a tabela de rotas (**route table**), para determinar qual será a **interface de rede de saída** que será usada para **encaminhar o pacote**. Em outras palavras, a decisão de roteamento é baseada exclusivamente no **endereço de destino**, processo que também é chamado de **Roteamento por Destino (destination-based routing)**.

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

Muitas vezes, o **Policy Routing** é chamado de **roteamento inteligente** pois permite tomar decisões de roteamento com base não apenas no endereço de destino, mas também em outras propriedades dos pacotes, como endereço de origem, portas TCP/UDP, marcações em pacotes, campo ToS (Type of Service), interface de entrada, dados do pacote (payload), entre outros.

Normalmente, a configuração de **Policy Routing** divide‑se em duas etapas:

1. Criar várias tabelas de rotas.
2. Definir regras (policy rules) que escolhem, para cada pacote, qual tabela utilizar.

### Múltiplas Tabelas de Rotas

A funcionalidade de **Policy Routing**, presente no Linux desde o Kernel 2.2, permite criar e configurar múltiplas tabelas de rotas. Ao contrário do roteamento tradicional, que usa apenas a tabela de rotas principal, o **Policy Routing** possibilita ter várias tabelas de roteamento independentes, cada uma contendo as suas próprias regras de roteamento.

Por padrão, o Linux vem configurado com **quatro tabelas de rotas** definidas no arquivo ```/etc/iproute2/rt_tables```:

```shell
$ cat /etc/iproute2/rt_tables
#
# reserved values
#
255     local
254     main
253     default
0       unspec
#
# local
#
```

As tabelas são identificadas internamente pelo kernel por IDs numéricos que vão de 0 a 255 e, opcionalmente podem ser referenciadas por um respectivo nome. Para que um nome seja associado a um ID é preciso declará‑lo no arquivo ```/etc/iproute2/rt_tables``` pois, o Kernel lê esse arquivo na inicialização para reconhecer as tabelas nomeadas.

- **unspec (0)**
    - Tabela reservada pelo sistema e não é usada como tabela de roteamento ativa. 
    - É utilizada para operações internas e comandos para manipulação de rotas quando não é explicitamente especifidado um tabela.

- **local (255)**
    - A tabela local (ID 255) contém rotas para endereços locais do sistema (local delivery), incluindo endereços broadcast, multicast e loopback.
    - Tem prioridade alta na decisão de roteamento onde, o Kernel consulta para determinar se um pacote é destinado ao próprio host.

- **main (254)**
    - É a tabela de roteamento padrão usada pelo Linux.
    - Toda manipulação de rotas, quando não se aplicam critérios de **Policy Routing**, devem ser feitas nesta tabela.

- **default (253)**
    - Tabela reservada para processametno posterior quando não houver nenhuma combinação de regra presente na tabela **main**.

Na prática, a tabela **main** é a única que normalmente se manipula manualmente. As demais devem ser deixadas para o Kernel gerenciar. Por exemplo, a tabela **unspec** não permite adição de rotas, é controlada apenas pelo Kernel.

Por exemplo, para visualizar o conteúdo de uma tabela é possível usar seu nome ou ID numérico:

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

A ideia de ter múltiplas tabelas é justamente ter diferentes regras de roteamento (rotas) que podem ser usadas por regras definidas com comando ```ip rule```. Sem essas regras, não há critério de seleção e o kernel passa a usar apenas a tabela **main** para decisão de roteamento.

No OCI, por exemplo, configurar corretamente o **Policy Routing** é obrigatório quando uma instância com função de roteador/firewall possui múltiplas VNICs em sub‑redes diferentes com gateways diferentes.

## Fluxo dos Pacotes dentro da Caixa