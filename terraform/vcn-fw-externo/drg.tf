#
# vcn-fw-externo/drg.tf
#

# DRG - Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-externo_vcn-fw-externo_imp-rt-dst" {
    drg_id = var.drg_id
    distribution_type = "IMPORT"
    display_name = "import-routes_vcn-fw-externo"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-externo_vcn-fw-externo_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_vcn-fw-externo_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE" 
        attachment_type = "VIRTUAL_CIRCUIT"               
    }

    priority = 1
}

# DRG - Import Route Distribution Statement #2
resource "oci_core_drg_route_distribution_statement" "drg-externo_vcn-fw-externo_imp-rt-dst_stm-2" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_vcn-fw-externo_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE" 
        attachment_type = "IPSEC_TUNNEL"               
    }

    priority = 2
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-externo-rt_vcn-fw-externo" {  
    drg_id = var.drg_id
    display_name = "drg-attch-rt_vcn-fw-externo"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-externo_vcn-fw-externo_imp-rt-dst.id
}

# DRG Attachment
resource "oci_core_drg_attachment" "drg-externo-attch_vcn-fw-externo" {
    drg_id = var.drg_id
    display_name = "drg-attch_vcn-fw-externo"

    network_details {
        id = oci_core_vcn.vcn-fw-externo.id
        route_table_id = oci_core_route_table.vcn-fw-externo_rt.id
        type = "VCN" 
        vcn_route_type = "VCN_CIDRS"                      
    }

    drg_route_table_id = oci_core_drg_route_table.drg-externo-rt_vcn-fw-externo.id
}