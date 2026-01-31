#
# drg-interno-remotepeering.tf
#

resource "oci_core_remote_peering_connection" "drg-interno_rpc" {
    compartment_id = var.root_compartment
    drg_id = oci_core_drg.drg-interno.id      
    
    display_name = "rpc_drg-externo"
    peer_region_name = "sa-saopaulo-1"
    peer_id = oci_core_remote_peering_connection.drg-externo_rpc.id
}

# Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-interno_rpc_imp-rt-dst" {
    drg_id = oci_core_drg.drg-interno.id
    distribution_type = "IMPORT"
    display_name = "drg-interno_import-routes_rpc"
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-interno_rpc_rt" {  
    drg_id = oci_core_drg.drg-interno.id
    display_name = "drg-interno_rpc_rt"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_rpc_imp-rt-dst.id
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-interno_rpc_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_rpc_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID" 
        drg_attachment_id = module.vcn-appl-1.drg-attch_id                
    }

    priority = 1
}

# Anexa a tabela de roteamento ao Remote Peering.
resource "oci_core_drg_attachment_management" "drg-interno_rpc-attch" {
  compartment_id = var.root_compartment
  drg_id = oci_core_drg.drg-interno.id
  display_name = "rpc_attch"

  attachment_type = "REMOTE_PEERING_CONNECTION"  
  network_id = oci_core_remote_peering_connection.drg-interno_rpc.id
  drg_route_table_id = oci_core_drg_route_table.drg-interno_rpc_rt.id
}