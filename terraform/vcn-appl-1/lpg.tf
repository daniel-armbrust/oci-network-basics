#
# vcn-appl-1/lpg.tf
#

resource "oci_core_local_peering_gateway" "lpg_vcn-appl-1_vcn-db" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-appl-1.id
    display_name = "lpg_vcn-appl-1_vcn-db"
}