#
# datasource.tf
# 

data "external" "retora_meu_ip-publico" {
    program = ["bash", "./scripts/get-my-publicip.sh"]
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_services
#
data "oci_core_services" "gru_all_oci_services" {
    filter {
       name   = "name"
       values = ["All .* Services In Oracle Services Network"]
       regex  = true
    }
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains
#
data "oci_identity_availability_domains" "gru_ads" {
    compartment_id = var.tenancy_id
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_fault_domains
#
data "oci_identity_fault_domains" "gru_fds" {
    compartment_id = var.tenancy_id
    availability_domain = local.ads["gru_ad1_name"]
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/objectstorage_namespace
#
data "oci_objectstorage_namespace" "objectstorage_ns" {
    compartment_id = var.tenancy_id
}

#
# DRG-INTERNO Remote Peering Attachment
#
data "oci_core_drg_attachments" "drg-interno_rpc-attch" {
    compartment_id = var.root_compartment
    attachment_type = "REMOTE_PEERING_CONNECTION"
    drg_id = oci_core_drg.drg-interno.id
}

#
# DRG-EXTERNO Remote Peering Attachment
#
data "oci_core_drg_attachments" "drg-externo_rpc-attch" {
    compartment_id = var.root_compartment
    attachment_type = "REMOTE_PEERING_CONNECTION"
    drg_id = oci_core_drg.drg-externo.id
}

#
# DRG-INTERNO VCN-FW-INTERNO Attachment
#
data "oci_core_drg_attachments" "drg-interno-attch_vcn-fw-interno" {
    compartment_id = var.root_compartment
    attachment_type = "VCN"    
    drg_id = oci_core_drg.drg-interno.id

    // NOTA: Este atributo depende do valor de DISPLAY_NAME do 
    // Attachment da VCN-FW-INTERNO.
    display_name = "drg-attch_vcn-fw-interno"

    depends_on = [
        oci_core_remote_peering_connection.drg-interno_rpc,
        module.vcn-fw-interno
    ]
}

#
# DRG-EXTERNO VCN-FW-EXTERNO Attachment
#
data "oci_core_drg_attachments" "drg-externo-attch_vcn-fw-externo" {
    compartment_id = var.root_compartment
    attachment_type = "VCN"    
    drg_id = oci_core_drg.drg-externo.id

    // NOTA: Este atributo depende do valor de DISPLAY_NAME do 
    // Attachment da VCN-FW-EXTERNO.
    display_name = "drg-attch_vcn-fw-externo"

    depends_on = [
        oci_core_remote_peering_connection.drg-externo_rpc,
        module.vcn-fw-externo
    ]
}