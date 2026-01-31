#
# vcn-appl-1/drg.tf
#

# DRG - Import Route Distribution
resource "oci_core_drg_route_distribution" "drg-interno_vcn-appl-1_imp-rt-dst" {
    drg_id = var.drg_id
    distribution_type = "IMPORT"
    display_name = "import-routes_vcn-appl-1"
}

# DRG - Import Route Distribution Statement #1
resource "oci_core_drg_route_distribution_statement" "drg-interno_vcn-appl-1_imp-rt-dst_stm-1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-1_imp-rt-dst.id
    
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID" 
        drg_attachment_id = var.vcn-appl-2_drg-attch_id                    
    }

    priority = 1
}

# DRG Route Table
resource "oci_core_drg_route_table" "drg-interno-rt_vcn-appl-1" {  
    drg_id = var.drg_id
    display_name = "drg-attch-rt_vcn-appl-1"
   
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg-interno_vcn-appl-1_imp-rt-dst.id
}

# FIREWALL INTERNO
resource "oci_core_drg_route_table_route_rule" "drg-interno_vcn-appl-1_rt-routerule-1" {
    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-appl-1.id

    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"

    next_hop_drg_attachment_id = var.drg-interno-attch_vcn-fw-interno_id
}

# Rede das Aplicações On-Premises (vm-ipsec)
resource "oci_core_drg_route_table_route_rule" "drg-interno_vcn-appl-1_rt-routerule-2" {
    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-appl-1.id
    
    destination = "${var.onpremises_rede-app_cidr}"
    destination_type = "CIDR_BLOCK"

    next_hop_drg_attachment_id = var.drg-interno_rpc_id
}

# DRG Attachment
resource "oci_core_drg_attachment" "drg-interno-attch_vcn-appl-1" {
    drg_id = var.drg_id
    display_name = "drg-attch_vcn-appl-1"

    network_details {
        id = oci_core_vcn.vcn-appl-1.id
        type = "VCN"
        vcn_route_type = "VCN_CIDRS"               
    }

    drg_route_table_id = oci_core_drg_route_table.drg-interno-rt_vcn-appl-1.id
}