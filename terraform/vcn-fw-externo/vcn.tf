#
# vcn-fw-externo/vcn.tf
#

resource "oci_core_vcn" "vcn-fw-externo" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    ipv6private_cidr_blocks = ["${var.vcn_ipv6_cidr}"]
    is_ipv6enabled = true
    display_name = "vcn-fw-externo"
    dns_label = "vcnfwexterno"
}