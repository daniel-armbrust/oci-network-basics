#
# onpremises/routetable.tf
#

resource "oci_core_route_table" "rt_subnpub-internet_vcn-onpremises" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "rt_subnpub-1"   

    # Internet Gateway
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"        
        network_entity_id = oci_core_internet_gateway.igw_vcn-onpremises.id        
    }
}

resource "oci_core_route_table" "rt_subnprv-rede-app_vcn-onpremises" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "rt_subnprv-rede-app"   

    # IP Privado da VM-IPSEC
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"        
        network_entity_id = "${data.oci_core_private_ips.onpremises_vm-ipsec_private_ips.private_ips[0].id}"  
    }

    # Service Gateway
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"        
        network_entity_id = oci_core_service_gateway.sgw_vcn-onpremises.id        
    }

    depends_on = [
        oci_core_instance.vm-ipsec
    ]
}

resource "oci_core_route_table" "rt_subnprv-rede-backup_vcn-onpremises" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "rt_subnprv-rede-backup"   

    # IP Privado da VM-IPSEC
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"        
        network_entity_id = "${data.oci_core_private_ips.onpremises_vm-ipsec_private_ips.private_ips[0].id}"  
    }
    
    # Service Gateway
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"        
        network_entity_id = oci_core_service_gateway.sgw_vcn-onpremises.id        
    }

    depends_on = [
        oci_core_instance.vm-ipsec
    ]
}