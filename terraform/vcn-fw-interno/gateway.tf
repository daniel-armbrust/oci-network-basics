#
# vcn-fw-interno/gateway.tf
#

# Service Gateway
resource "oci_core_service_gateway" "sgw_vcn-fw-interno" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    display_name = "sgw"

    services {     
        service_id = var.sgw_all_oci_services
    }
}