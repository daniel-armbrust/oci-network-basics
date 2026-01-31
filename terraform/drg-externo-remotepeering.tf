#
# drg-externo-remotepeering.tf
#

resource "oci_core_remote_peering_connection" "drg-externo_rpc" {
    compartment_id = var.root_compartment

    drg_id = oci_core_drg.drg-externo.id   
    display_name = "rpc_drg-interno"
}

# Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-externo_rpc_imp-rt-dst" {
    drg_id = oci_core_drg.drg-externo.id
    distribution_type = "IMPORT"
    display_name = "drg-externo_import-routes_rpc"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-externo_rpc_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_rpc_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE" 
        attachment_type = "VCN"               
    }

    priority = 1
}

# DRG - Import Route Distribution Statement #2
resource "oci_core_drg_route_distribution_statement" "drg-externo_rpc_imp-rt-dst_stm-2" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_rpc_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE" 
        attachment_type = "VIRTUAL_CIRCUIT"               
    }

    priority = 2
}

# DRG - Import Route Distribution Statement #3
resource "oci_core_drg_route_distribution_statement" "drg-externo_rpc_imp-rt-dst_stm-3" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_rpc_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE" 
        attachment_type = "IPSEC_TUNNEL"               
    }

    priority = 3
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-externo_rpc_rt" {  
    drg_id = oci_core_drg.drg-externo.id
    display_name = "drg-externo_rpc_rt"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_rpc_imp-rt-dst.id
}

# Anexa a tabela de roteamento ao Remote Peering.
resource "oci_core_drg_attachment_management" "drg-externo_rpc-attch" {
  compartment_id = var.root_compartment
  drg_id = oci_core_drg.drg-externo.id
  display_name = "rpc_attch"

  attachment_type = "REMOTE_PEERING_CONNECTION"  
  network_id = oci_core_remote_peering_connection.drg-externo_rpc.id
  drg_route_table_id = oci_core_drg_route_table.drg-externo_rpc_rt.id
}