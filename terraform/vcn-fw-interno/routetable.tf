#
# vcn-fw-interno/routetable.tf
#

# Route Table - Sub-rede Privada LAN
resource "oci_core_route_table" "rt_subnprv-1" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
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

# VCN Route Table - TO-FIREWALL
resource "oci_core_route_table" "vcn-fw-interno_rt" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    display_name = "vcn-fw-interno_rt"

    # Rota para o NLB do Firewall Interno IPv4
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"   
        network_entity_id = var.nlb_fw-interno_ip_id
    }
}