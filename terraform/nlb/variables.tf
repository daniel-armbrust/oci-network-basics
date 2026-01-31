#
# nlb/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

#------------------------#
# NLB - Firewall Interno #
#------------------------#

variable "firewall-1_appl-ip" {
    description = "Endereço IP LAN do Firewall Interno #1."
    type = string
}

variable "firewall-2_appl-ip" {
    description = "Endereço IP LAN do Firewall Interno #2."
    type = string
}

variable "nlb_fw-interno_ip" {
    description = "Endereço IP do NLB do Firewall Interno."
    type = string
}

variable "fw-interno_subnet_id" {
    description = "ID da Sub-rede do Firewall Interno."
    type = string
}

#------------------------#
# NLB - Firewall Externo #
#------------------------#

variable "firewall-1_externo-ip" {
    description = "Endereço IP do Firewall Externo #1."
    type = string
}

variable "firewall-2_externo-ip" {
    description = "Endereço IP do Firewall Externo #2."
    type = string
}

variable "nlb_fw-externo_ip" {
    description = "Endereço IP do Firewall Externo."
    type = string
}

variable "fw-externo_subnet_id" {
    description = "ID da Sub-rede do Firewall Externo."
    type = string
}