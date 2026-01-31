#
# vcn-appl-2/drg.tf
#

# DRG - Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-interno_vcn-appl-2_imp-rt-dst" {
    drg_id = var.drg_id
    distribution_type = "IMPORT"
    display_name = "import-routes_vcn-appl-2"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-interno_vcn-appl-1_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-2_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID" 
        drg_attachment_id = var.vcn-appl-1_drg-attch_id                    
    }

    priority = 1
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-interno-rt_vcn-appl-2" {  
    drg_id = var.drg_id
    display_name = "drg-attch-rt_vcn-appl-2"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-2_imp-rt-dst.id
}

# FIREWALL
resource "oci_core_drg_route_table_route_rule" "drg-interno_vcn-appl-2_rt-routerule-1" {
    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-appl-2.id
    
    // Firewall Interno
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"

    next_hop_drg_attachment_id = var.drg-interno-attch_vcn-fw-interno_id
}

# DRG Attachment
resource "oci_core_drg_attachment" "drg-interno-attch_vcn-appl-2" {
    drg_id = var.drg_id
    display_name = "drg-attch_vcn-appl-2"

    network_details {
        id = oci_core_vcn.vcn-appl-2.id
        type = "VCN"
        vcn_route_type = "VCN_CIDRS"                
    }

    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-appl-2.id
}