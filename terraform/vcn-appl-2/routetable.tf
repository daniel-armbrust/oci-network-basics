#
# vcn-appl-2/routetable.tf
#

# Route Table - Sub-rede Privada #1 (subnprv-1)
resource "oci_core_route_table" "rt_subnprv-1_vcn-appl-2" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-appl-2.id
    display_name = "rt_subnprv-1"   

    # Service Gateway
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"        
        network_entity_id = oci_core_service_gateway.sgw_vcn-appl-2.id        
    }

    # DRG IPv4
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = var.drg_id     
    }

    # DRG IPv6
    route_rules {
        destination = "::/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = var.drg_id
    }
}