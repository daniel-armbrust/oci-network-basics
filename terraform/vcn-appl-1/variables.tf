#
# vcn-appl-1/variables.tf
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

variable "drg-interno-attch_vcn-fw-interno_id" {
    description = "DRG-INTERNO VCN-FW-INTERNO Attachment ID"
    type = string
}

variable "vcn-appl-2_drg-attch_id" {
    description = "DRG Attachment ID da VCN-APPL-2"
    type = string
}

variable "vcn-fw-interno_drg-attch_id" {
    description = "DRG Attachment ID da VCN-FW-INTERNO"
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

variable "onpremises_rede-app_cidr" {
    description = "On-Premises - Rede das Aplicações"
    type = string
}

variable "drg-interno_rpc_id" {
    description = "DRG-INTERNO Remote Peering Connection ID"
    type = string
}