#
# vcn-db/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados"
    type = string  
}

variable "sgw_all_oci_services" {
    description = "All GRU Services In Oracle Services Network"
    type = string
}

variable "vcn_cidr" {
    description = "Prefixo IPv4 em notação CIDR"
    type = string
}

variable "vcn_ipv6_cidr" {
    description = "Lista de Prefixos IPv6"
    type = string
}

variable "subnprv_cidr" {
    description = "Prefixo IPv4 da Sub-rede Privada"
    type = string
}

variable "subnprv_ipv6_cidr" {
    description = "Prefixo IPv6 da Sub-rede Privada"
    type = string
}

variable "lpg_vcn-appl-1_id" {
    description = "LPG ID da VCN-APPL-1"
    type = string
}

variable "lpg_vcn-appl-2_id" {
    description = "LPG ID da VCN-APPL-2"
    type = string
}