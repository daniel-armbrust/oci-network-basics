#
# vcn-appl-2/vcn.tf
#

resource "oci_core_vcn" "vcn-appl-2" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    ipv6private_cidr_blocks = ["${var.vcn_ipv6_cidr}"]
    is_ipv6enabled = true
    is_oracle_gua_allocation_enabled = false
    display_name = "vcn-appl-2"
    dns_label = "vcnappl2"
}