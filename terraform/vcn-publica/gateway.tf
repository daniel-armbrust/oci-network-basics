#
# vcn-publica/gateway.tf
#

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-publica.id
    display_name = "igw"
    enabled = true
}