#
# vcn-publica/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "vcn_cidr" {
    description = "Prefixo IPv4 em notação CIDR"
    type = string
}

variable "subnpub-internet_cidr" {
    description = "Prefixo IPv4 da Sub-rede Pública"
    type = string
}

variable "meu_ip-publico" {
    description = "Meu endereço IP Público"
    type = string
}