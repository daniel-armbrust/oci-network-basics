#
# vm-firewall/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados"
    type = string  
}

variable "availability_domain" {
    description = "Nome do Availability Domain"
    type = string
}

variable "os_image_id" {
    description = "OCID da imagem do Sistema Operacional"
    type = string
}

#----------------#
# VCN-FW-INTERNO #
#----------------#

variable "vcn-fw-interno_cidr" {
    description = "Prefixo IPv4 da VCN-FIREWALL-INTERNO em notação CIDR"
    type = string 
}

variable "vcn-fw-interno_subnprv-1_ip-gw" {
    description = "Endereço IPv4 do Gateway da Sub-rede privada"
    type = string
}

variable "vcn-fw-interno_ipv6_cidr" {
    description = "Prefixo IPv6 da VCN-FIREWALL-INTERNO em notação CIDR"
    type = string 
}

variable "vcn-fw-interno_subnprv-1_ipv6_cidr" {
    description = "Prefixo IPv6 da Sub-rede privada VCN-FIREWALL-INTERNO"
    type = string
}

variable "vcn-fw-interno_subnprv-1_ipv6-gw" {
    description = "Endereço IPv6 do Gateway da Sub-rede privada VCN-FIREWALL-INTERNO"
    type = string
}

variable "vcn-fw-interno_subnprv-1_id" {
    description = "OCID da Sub-rede privada VCN-FIREWALL-INTERNO"
    type = string
}

#----------------#
# VCN-FW-EXTERNO #
#----------------#

variable "vcn-fw-externo_cidr" {
    description = "Prefixo IPv4 da VCN-FIREWALL-EXTERNO em notação CIDR"
    type = string 
}

variable "vcn-fw-externo_subnprv-1_ip-gw" {
    description = "Endereço IPv4 do Gateway da Sub-rede privada"
    type = string
}

variable "vcn-fw-externo_ipv6_cidr" {
    description = "Prefixo IPv6 da VCN-FIREWALL-EXTERNO em notação CIDR"
    type = string 
}

variable "vcn-fw-externo_subnprv-1_ipv6_cidr" {
    description = "Prefixo IPv6 da Sub-rede privada VCN-FIREWALL-EXTERNO"
    type = string
}

variable "vcn-fw-externo_subnprv-1_ipv6-gw" {
    description = "Endereço IPv6 do Gateway da Sub-rede privada VCN-FIREWALL-EXTERNO"
    type = string
}

variable "vcn-fw-externo_subnprv-1_id" {
    description = "OCID da Sub-rede privada VCN-FIREWALL-EXTERNO"
    type = string
}

#------------#
# VCN-APPL-1 #
#------------#

variable "vcn-appl-1_cidr" {
    description = "Prefixo IPv4 da VCN-APPL-1 em notação CIDR"
    type = string
}

variable "vcn-appl-1_ipv6_cidr" {
    description = "Prefixo IPv6 da VCN-APPL-1 em notação CIDR"
    type = string
}

#------------#
# VCN-APPL-2 #
#------------#

variable "vcn-appl-2_cidr" {
    description = "Prefixo IPv4 da VCN-APPL-2 em notação CIDR"
    type = string
}

variable "vcn-appl-2_ipv6_cidr" {
    description = "Prefixo IPv6 da VCN-APPL-2 em notação CIDR"
    type = string
}

#-------------#
# VCN-PUBLICA #
#-------------#

variable "vcn-publica_subnpub-1_ip-gw" {
    description = "Endereço IPv4 do Gateway da Sub-rede pública"
    type = string
}

variable "vcn-publica_subnpub-1_id" {
    description = "OCID da Sub-rede privada VCN-FIREWALL-INTERNO"
    type = string
}

#-------------#
# FIREWALL #1 #
#-------------#

variable "firewall-1_appl-ip" {
    description = "Endereço IPv4 APPL do Firewall #1"
    type = string
}

variable "firewall-1_externo-ip" {
    description = "Endereço IPv4 EXTERNO do Firewall #1"
    type = string
}

variable "firewall-1_appl-ipv6" {
    description = "Endereço IPv6 APPL do Firewall #1"
    type = string
}

variable "firewall-1_externo-ipv6" {
    description = "Endereço IPv6 EXTERNO do Firewall #1"
    type = string
}

variable "firewall-1_internet-ip" {
    description = "Endereço IPv4 INTERNET do Firewall #1"
}

#-------------#
# FIREWALL #2 #
#-------------#

variable "firewall-2_appl-ip" {
    description = "Endereço IPv4 APPL do Firewall #"
    type = string
}

variable "firewall-2_externo-ip" {
    description = "Endereço IPv4 EXTERNO do Firewall #2"
    type = string
}

variable "firewall-2_appl-ipv6" {
    description = "Endereço IPv6 APPL do Firewall #2"
    type = string
}

variable "firewall-2_externo-ipv6" {
    description = "Endereço IPv6 EXTERNO do Firewall #2"
    type = string
}

variable "firewall-2_internet-ip" {
    description = "Endereço IPv4 INTERNET do Firewall #1"
}

#-------------#
# On-Premises #
#-------------#

variable "onpremises_internet_cidr" {
    description = "CIDR da Rede On-premises Internet."
    type = string
}

variable "onpremises_rede-app_cidr" {
    description = "CIDR da Rede On-premises das Aplicações."
    type = string
}

variable "onpremises_rede-backup_cidr" {
    description = "CIDR da Rede On-premises de Backup."
    type = string
}