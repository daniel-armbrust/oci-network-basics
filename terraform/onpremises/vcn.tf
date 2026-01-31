#
# onpremises/vcn.tf
#

resource "oci_core_vcn" "vcn-onpremises" {
    compartment_id = var.root_compartment
    cidr_blocks = "${var.vcn_cidr}"
    display_name = "vcn-onpremises"
    dns_label = "vcnonprem"
}