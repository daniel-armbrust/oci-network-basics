#
# onpremises/gateway.tf
#

# Service Gateway
resource "oci_core_service_gateway" "sgw_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "sgw"

    services {     
        service_id = var.sgw_all_oci_services
    }
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "igw"
    enabled = true
}