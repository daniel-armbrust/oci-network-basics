# Hub & Spoke com Local Peering Gateway (LPG)

## Local Peering Gateway (LPG)

O _[Local Peering Gateway (LPG)](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/localVCNpeering.htm)_ é utilizado para conectar duas VCNs diretamente. Hoje, já não é mais recomendado utilizar LPGs para conectar VCNs. A função que o LPG desempenha foi substituída pelo _[DRG](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDRGs.htm)_, que é o modo atualmente recomendado para se construír topologias de redes no OCI.

EU particularmente, ainda vejo diversas topologias que utilizam LPGs para interconectar VCNs. Por esse motivo, considero importante compreender como o roteamento funciona quando existe um LPG realizando a comunicação entre as VCNs.

## Fluxo de Roteamento

Observe o diagrama abaixo, que ilustra a topologia de estudo utilizando LPG:

![DRG #1](img/oci-lpg-routing-1.png)

