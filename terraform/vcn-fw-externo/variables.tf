#
# vcn-fw-externo/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados"
    type = string  
}

variable "drg_id" {
    description = "OCID do DRG"
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

variable "subnprv-1_cidr" {
    description = "Prefixo IPv4 da Sub-rede Privada"
    type = string
}

variable "subnprv-1_ipv6_cidr" {
    description = "Prefixo IPv6 da Sub-rede Privada"
    type = string
}

variable "nlb_fw-externo_ip_id" {
    description = "OCID do IP privado do Network Load Balancer."
    type = string
}

variable "vcn-appl-1_cidr" {
    description = "VCN-APPL-1 IPv4 CIDR"
    type = string
}

variable "vcn-appl-1_ipv6_cidr" {
    description = "VCN-APPL-1 IPv6 CIDR"
    type = string
}

variable "vcn-appl-2_cidr" {
    description = "VCN-APPL-2 IPv4 CIDR"
    type = string
}

variable "vcn-appl-2_ipv6_cidr" {
    description = "VCN-APPL-2 IPv6 CIDR"
    type = string
}