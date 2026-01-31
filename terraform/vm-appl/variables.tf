#
# compute/variables.tf
#

variable "root_compartment" {
    description = "Compartimento raiz onde os recursos serão criados."
    type = string  
}

variable "appl-1_ip" {
    description = "Endereço IP da VM de Aplicação APPL-1"
    type = string
}

variable "appl-1_subnprv_id" {
    description = "ID da Sub-rede Privada da VM de Aplicação APPL-1"
    type = string
}

variable "appl-2_ip" {
    description = "Endereço IP da VM de Aplicação APPL-2"
    type = string
}

variable "appl-2_subnprv_id" {
    description = "ID da Sub-rede Privada da VM de Aplicação APPL-2"
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