#
# vcn-appl-1/vcn.tf
#

resource "oci_core_vcn" "vcn-appl-1" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    ipv6private_cidr_blocks = ["${var.vcn_ipv6_cidr}"]
    is_ipv6enabled = true
    is_oracle_gua_allocation_enabled = false
    display_name = "vcn-appl-1"
    dns_label = "vcnappl1"
}