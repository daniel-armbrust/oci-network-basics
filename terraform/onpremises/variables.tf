#
# onpremises/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "availability_domain" {
    description = "Nome do Availability Domain."
    type = string
}

variable "os_image_id" {
    description = "ID da imagem do Sistema Operacional."
    type = string
}

variable "sgw_all_oci_services" {
    description = "All GRU Services In Oracle Services Network."
    type = string
}

variable "meu_ip-publico" {
    description = "Meu endereço IP Publico."
    type = string
}

variable "vcn_cidr" {
    type = list
}

#---------------------#
# VM IPSec - Internet #
#---------------------#

variable "vm-ipsec_internet_cidr" {
    description = "CIDR da Rede de Internet."
    type = string
}

variable "vm-ipsec_internet-ip" {
    description = "Endereço IP Privado da VNIC de Internet."
    type = string
}

variable "vm-ipsec_internet-ip-gw" {
    description = "Endereço IP Privado do Gateway da VNIC de Internet."
    type = string
}

variable "vm-ipsec_public-ip" {
    description = "Endereço IP Publico Reservado da VM-IPSEC On-premises."
    type = string
}

variable "vm-ipsec_public-ip_id" {
    description = "OCID do Endereço IP Publico Reservado da VM-IPSEC On-premises."
    type = string
}

variable "reserved-public-ip_id" {
    description = "OCID do Endereço IP Público Reservado."
    type = string
}

#--------------------------------#
# VM IPSec - Rede das Aplicações #
#--------------------------------#

variable "vm-ipsec_rede-app_cidr" {
    description = "CIDR da Rede das Aplicações."
    type = string
}

variable "vm-ipsec_rede-app-ip" {
    description = "Endereço IP Privado da VNIC da Rede das Aplicações."
    type = string
}

variable "vm-ipsec_rede-app-ip-gw" {
    description = "Endereço IP Privado do Gateway da VNIC da Rede das Aplicações."
    type = string
}

#---------------------------#
# VM IPSec - Rede de Backup #
#---------------------------#

variable "vm-ipsec_rede-backup_cidr" {
    description = "CIDR da Rede de Backup."
    type = string
}

variable "vm-ipsec_rede-backup-ip" {
    description = "Endereço IP Privado da VNIC da Rede de Backup."
    type = string
}

variable "vm-ipsec_rede-backup-ip-gw" {
    description = "Endereço IP Privado do Gateway da VNIC da Rede de Backup."
    type = string
}

#-----#
# ASN #
#-----#

variable "ipsec-onpremises_asn" {
    description = "On-premises BGP ASN."
    type = string
}

variable "ipsec_oracle_asn" {
    description = "Oracle BGP ASN."
    type = string
}

#-----------#
# Tunnel #1 #
#-----------#

variable "ipsec_tunnel-1_bgp-local-ip" {
    description = "On-premises IPSec Tunnel #1 - BGP IP"
    type = string
}

variable "ipsec_tunnel-1_bgp-oci-ip" {
    description = "OCI IPSec Tunnel #1 - BGP IP"
    type = string
}

variable "ipsec_tunnel-1_bgp-cidr" {
    description = "OCI IPSec Tunnel #1 - BGP CIDR"
    type = string
}

variable "ipsec_tunnel-1_bgp-oci-public-ip" {
    description = "OCI IPSec Tunnel #1 - IP Público"
    type = string
}

variable "ipsec_tunnel-1_shared-secret" {
    description = "OCI IPSec Shared Secret #1 - IP Público"
    type = string
}

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

variable "ipsec_tunnel-2_bgp-local-ip" {
    description = "On-premises IPSec Tunnel #2 - BGP IP"
    type = string
}

variable "ipsec_tunnel-2_bgp-oci-ip" {
    description = "OCI IPSec Tunnel #2 - BGP IP"
    type = string
}

variable "ipsec_tunnel-2_bgp-cidr" {
    description = "OCI IPSec Tunnel #2 - BGP CIDR"
    type = string
}

variable "ipsec_tunnel-2_bgp-oci-public-ip" {
    description = "OCI IPSec Tunnel #2 - IP Público"
    type = string
}

variable "ipsec_tunnel-2_shared-secret" {
    description = "OCI IPSec Shared Secret #2 - IP Público"
    type = string
}

variable "ipsec_tunnel-2_bgp-local-ip-mask" {
    description = "Endereço IP e Máscara cliente #2."
    type = string
}

variable "ipsec_tunnel-2_bgp-oci-ip-mask" {
    description = "Endereço IP e Máscara OCI #2."
    type = string
}