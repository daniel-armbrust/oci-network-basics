#
# vpn-ipsec/drg.tf
#

# DRG - Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-externo_vpn-ipsec_imp-rt-dst" {
    drg_id = var.drg_id
    distribution_type = "IMPORT"
    display_name = "import-routes_vpn-ipsec"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-externo_vpn-ipsec_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_vpn-ipsec_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE"      
        attachment_type = "VCN"         
    }

    priority = 1
}

# DRG - Import Route Distribution Statement #2
resource "oci_core_drg_route_distribution_statement" "drg-externo_vpn-ipsec_imp-rt-dst_stm-2" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_vpn-ipsec_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE"      
        attachment_type = "REMOTE_PEERING_CONNECTION"         
    }

    priority = 2
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-externo_vpn-ipsec_rt" {  
    drg_id = var.drg_id
    display_name = "drg-attch-rt_vpn-ipsec"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_vpn-ipsec_imp-rt-dst.id
}

resource "oci_core_drg_attachment_management" "drg-externo_vpn-ipsec-attch_tunnel-1" {
   compartment_id = var.root_compartment
   drg_id = var.drg_id
   display_name = "vpn-ipsec-attch_tunnel-1"

   attachment_type = "IPSEC_TUNNEL"   
   network_id = data.oci_core_ipsec_connection_tunnels.onpremises_ipsec_tunnels.ip_sec_connection_tunnels[0].id
   drg_route_table_id = oci_core_drg_route_table.drg-externo_vpn-ipsec_rt.id

   depends_on = [
       oci_core_ipsec_connection_tunnel_management.onpremises_ipsec_tunnel-1
   ]   
}

resource "oci_core_drg_attachment_management" "drg-externo_vpn-ipsec-attch_tunnel-2" {
   compartment_id = var.root_compartment
   drg_id = var.drg_id
   display_name = "vpn-ipsec-attch_tunnel-2"

   attachment_type = "IPSEC_TUNNEL"   
   network_id = data.oci_core_ipsec_connection_tunnels.onpremises_ipsec_tunnels.ip_sec_connection_tunnels[1].id
   drg_route_table_id = oci_core_drg_route_table.drg-externo_vpn-ipsec_rt.id

   depends_on = [
       oci_core_ipsec_connection_tunnel_management.onpremises_ipsec_tunnel-2
   ]   
}