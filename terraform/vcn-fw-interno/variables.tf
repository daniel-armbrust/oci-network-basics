#
# vcn-fw-interno/variables.tf
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

variable "nlb_fw-interno_ip_id" {
    description = "OCID do IP privado do Network Load Balancer"
    type = string
}

variable "vcn-appl-1_drg-attch_id" {
    description = "OCID do Attachment da VCN-APPL-1"
    type = string
}

variable "vcn-appl-2_drg-attch_id" {
    description = "OCID do Attachment da VCN-APPL-2"
    type = string
}

variable "vcn_cidr" {
    description = "Prefixo IPv4 da VCN em notação CIDR"
    type = string
}

variable "vcn_ipv6_cidr" {
    description = "Prefixo IPv6 da VCN em notação CIDR"
    type = string
}

variable "subnprv-appl_cidr" {
    description = "Prefixo IPv4 da Sub-rede Privada"
    type = string
}

variable "subnprv-appl_ipv6_cidr" {
    description = "Prefixo IPv6 da Sub-rede Privada"
    type = string
}