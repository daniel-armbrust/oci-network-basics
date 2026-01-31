#
# onpremises/output.tf
#

data "oci_core_private_ips" "onpremises_vm-ipsec_private_ips" {    
    ip_address = var.vm-ipsec_internet-ip  
    subnet_id = oci_core_subnet.subnpub-internet_vcn-onpremises.id
    ip_state = "AVAILABLE"

    depends_on = [
        oci_core_instance.vm-ipsec 
    ]    
}

data "oci_core_public_ips" "onpremises_public-ips" {
    compartment_id = var.root_compartment
    scope = "AVAILABILITY_DOMAIN"
    lifetime = "EPHEMERAL"

    availability_domain = var.availability_domain

    depends_on = [
        oci_core_instance.vm-ipsec 
    ] 
}