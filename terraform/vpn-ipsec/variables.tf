#
# vpn-ipsec/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "cpe_ip" {
    description = "Endereço IP Público do CPE."
    type = string  
}

variable "cpe_private-ip" {
    description = "Endereço IP Privado do CPE."
    type = string
}

variable "drg_id" {
    description = "OCID do DRG."
    type = string  
}

#---------------------------------#
# VCN-FW-EXTERNO - DRG Attachment #
#---------------------------------#

variable "vcn-fw-externo_drg-attch_id" {
    description = "VCN-FW-EXTERNO - DRG Attachment."
    type = string  
}

#-----#
# ASN #
#-----#

variable "ipsec-onpremises_asn" {
    description = "On-premises BGP ASN."
    type = string
}

#-----------#
# Tunnel #1 #
#-----------#

variable "ipsec_tunnel-1_bgp-local-ip-mask" {
    description = "Endereço IP e Máscara cliente #1."
    type = string
}

variable "ipsec_tunnel-1_bgp-oci-ip-mask" {
    description = "Endereço IP e Máscara OCI #1."
    type = string
}

#-----------#
# Tunnel #2 #
#-----------#

variable "ipsec_tunnel-2_bgp-local-ip-mask" {
    description = "Endereço IP e Máscara cliente #2."
    type = string
}

variable "ipsec_tunnel-2_bgp-oci-ip-mask" {
    description = "Endereço IP e Máscara OCI #2."
    type = string
}