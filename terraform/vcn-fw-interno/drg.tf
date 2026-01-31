#
# vcn-fw-interno/drg.tf
#

# DRG - Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-interno_vcn-fw-interno_imp-rt-dst" {
    drg_id = var.drg_id
    distribution_type = "IMPORT"
    display_name = "import-routes_vcn-fw-interno"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-interno_vcn-fw-interno_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-fw-interno_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID" 
        drg_attachment_id = var.vcn-appl-1_drg-attch_id              
    }

    priority = 1
}

# DRG - Import Route Distribution Statement #2
resource "oci_core_drg_route_distribution_statement" "drg-interno_vcn-fw-interno_imp-rt-dst_stm-2" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-fw-interno_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID" 
        drg_attachment_id = var.vcn-appl-2_drg-attch_id              
    }

    priority = 2
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-interno-rt_vcn-fw-interno" {  
    drg_id = var.drg_id
    display_name = "drg-attch-rt_vcn-fw-interno"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-fw-interno_imp-rt-dst.id
}

# DRG Attachment
resource "oci_core_drg_attachment" "drg-interno-attch_vcn-fw-interno" {
    drg_id = var.drg_id
    display_name = "drg-attch_vcn-fw-interno"

    network_details {
        id = oci_core_vcn.vcn-fw-interno.id
        route_table_id = oci_core_route_table.vcn-fw-interno_rt.id
        type = "VCN"
        vcn_route_type = "VCN_CIDRS"                       
    }

    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-fw-interno.id
}