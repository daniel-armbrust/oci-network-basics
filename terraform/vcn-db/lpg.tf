#
# vcn-db/lpg.tf
#

resource "oci_core_local_peering_gateway" "lpg_vcn_db_vcn-appl-1" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-db.id
    display_name = "lpg_vcn-db_vcn-appl-1"
    peer_id = var.lpg_vcn-appl-1_id
}


resource "oci_core_local_peering_gateway" "lpg_vcn_db_vcn-appl-2" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-db.id
    display_name = "lpg_vcn-db_vcn-appl-2"
    peer_id = var.lpg_vcn-appl-2_id
}