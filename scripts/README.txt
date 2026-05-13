README.txt
----------

1. Defina as variáveis de ambiente abaixo com os respectivos valores do seu tenancy OCI: 

$ export COMPARTMENT_ID=""
$ export SSH_PUB_KEY_PATH=""

2. Para criar a infraestrutura, acesse o diretório "create" e execute o script "./create.sh":

$ cd hub-spoke-com-local-peering-gateway/create
$ ./create.sh

3. Para destruir a infraestrutura, acesse o diretório "destroy" e execute o script ./destroy.sh:

$ cd hub-spoke-com-local-peering-gateway/destroy
$ ./destroy.sh