# Roteamento Avançado

Chamei de **Roteamento Avançado** porque essa topologia envolve mais recursos e decisões de roteamento do que o exemplo em [Roteamento via Firewall Central (hub & spoke)](./docs/roteamento-via-firewall-central.md). Os princípios são os mesmos, mas aqui há componentes adicionais que simulam um ambiente enterprise.

![Network Topology](/docs/img/oci-network-routing-1.png)

## Provisionamento

O código Terraform no diretório `terraform/` cria e configura todo o ambiente. Antes de executá-lo, crie o arquivo `terraform.tfvars`, que deve conter as variáveis específicas do tenancy utilizadas pelo código.

```bash
$ mv terraform.tfvars-example terraform.tfvars
```

Após ajustar o arquivo `terraform.tfvars`, gere um par de chaves SSH e coloque a chave pública em `terraform/ssh-keys/ssh-key.pub`. 

```bash
$ ls -1 terraform/ssh-keys/ssh-key.pub
terraform/ssh-keys/ssh-key.pub
```

Com isso, os recursos podem ser criados com Terraform a partir dos comandos abaixo:

```bash
$ terraform init
$ terraform apply
```

## Network Visualizer

O [Network Visualizer](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/network_visualizer.htm) é uma ferramenta do OCI útil para visualizar a topologia de rede criada em uma região. Acesse-a pelo menu **Network** > **Network Command Center**.

![Network Viualizer #1](/docs/img/network-visualizer-1.png)

Após abrir a ferramenta, selecione o compartimento que contém os recursos de rede e marque
**Include child compartments** para que seja feita uma varredura em todos os compartimentos filhos que estão abaixo do compartimento selecionado:

![Network Viualizer #2](/docs/img/network-visualizer-2.png)

Dica: **Sempre que possível, concentre os recursos de rede em um único compartimento. Caso seja necessário utilizar múltiplos compartimentos, organize-os de forma hierárquica sob um mesmo compartimento pai. Isso facilita a visualização e o entendimento da topologia do ambiente através do Network Viualizer.**

### Representação dos Componentes

O [Network Visualizer](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/network_visualizer.htm) usa símbolos para representar elementos da topologia:

- **Hexágono**
    - VCN

- **Círculo**
    - DRG

- **Quadrado/Retângulo**
    - Conexão IPSec ou FastConnect.

Cada conexão com o DRG é representada por um traço. No meio do traço há um pequeno círculo que indica a tabela de rotas do DRG.

![Network Viualizer #3](/docs/img/network-visualizer-3.png)

Há outros símbolos usados pelo [Network Visualizer](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/network_visualizer.htm) e, é recomendado sempre consultar a [documentação oficial](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/network_visualizer.htm) da ferramenta pois, novos símbolos podem ser disponibilizados.

### Análise de Roteamento

Suponha que você queira entender como um compute instance em uma sub-rede da VCN-APPL-1 se comunica com recursos da VCN-APPL-2. No exemplo, há uma instância chamada APPL-1 (10.50.10.10) na VCN-APPL-1 e outra chamada APPL-2 (10.60.10.10) na VCN-APPL-2.

```bash
[opc@appl1 ~]$ ping -c2 10.60.10.10
PING 10.60.10.10 (10.60.10.10) 56(84) bytes of data.
64 bytes from 10.60.10.10: icmp_seq=1 ttl=63 time=0.792 ms
64 bytes from 10.60.10.10: icmp_seq=2 ttl=63 time=0.687 ms

--- 10.60.10.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.687/0.739/0.792/0.052 ms
```

#### 1. Tabela de rotas do APPL-1 (10.50.10.10)

```bash
[opc@appl1 ~]$ ip route show
default via 10.50.10.1 dev enp0s6 proto dhcp src 10.50.10.10 metric 100 
10.50.10.0/24 dev enp0s6 proto kernel scope link src 10.50.10.10 metric 100 
169.254.0.0/16 dev enp0s6 proto dhcp scope link src 10.50.10.10 metric 100 
```

O comando `ip route show` mostra uma rota default (`default`) que envia todo o tráfego para o IP `10.50.10.1`, que é o gateway da sub-rede. Essa rota vale para todos os destinos, exceto `10.50.10.0/24` e `169.254.0.0/16`. 

#### 2. Tabela de rotas da sub-rede

Quando o tráfego chega ao gateway da sub-rede (`10.50.10.1`), a tabela de rotas da sub-rede (`rt_subnprv-1`) é consultada para determinar o próximo salto (next-hop).

![Network Viualizer #4](/docs/img/network-visualizer-4.png)

Nessa tabela há uma regra IPv4 que encaminha todo o tráfego para o DRG (`drg-interno`).

#### 3. Tabela de rotas do DRG

A próxima decisão de roteamento ocorre quando o pacote entra no DRG:

![Network Viualizer #5](/docs/img/network-visualizer-5.png)

Neste caso, consulta-se a tabela do DRG `drg-attch-rt_vcn-appl-1` para determinar o próximo salto.

![Network Viualizer #6](/docs/img/network-visualizer-6.png)

![Network Viualizer #7](/docs/img/network-visualizer-7.png)

Redes importadas para este anexo via route distribution `import-routes_vcn-appl-1`:

![Network Viualizer #8](/docs/img/network-visualizer-8.png)