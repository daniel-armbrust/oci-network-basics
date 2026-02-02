#
# vcn-appl-1/routetable.tf
#

# Route Table - Sub-rede Privada #1 (subnprv-1)
resource "oci_core_route_table" "rt_subnprv-1" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-appl-1.id
    display_name = "rt_subnprv-1"   

    # Service Gateway
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"        
        network_entity_id = oci_core_service_gateway.sgw.id        
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