#
# vcn-fw-externo/routetable.tf
#

# Route Table - Sub-rede Privada
resource "oci_core_route_table" "rt_subnprv-externo_vcn-fw-externo" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-externo.id
    display_name = "rt_subnprv-externo"   

    # Service Gateway
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"        
        network_entity_id = oci_core_service_gateway.sgw_vcn-fw-externo.id        
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
resource "oci_core_route_table" "vcn-fw-externo_rt" {   
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-externo.id
    display_name = "vcn-fw-externo_rt"

    route_rules {
        destination = "${var.vcn-appl-2_cidr}"
        destination_type = "CIDR_BLOCK"   
        network_entity_id = var.nlb_fw-externo_ip_id
    }
}