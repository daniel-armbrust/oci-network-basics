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