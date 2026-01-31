#
# vcn-fw-interno/vcn.tf
#

resource "oci_core_vcn" "vcn-fw-interno" {
    compartment_id = var.root_compartment
    cidr_blocks = ["${var.vcn_cidr}"]
    ipv6private_cidr_blocks = ["${var.vcn_ipv6_cidr}"]
    is_ipv6enabled = true
    is_oracle_gua_allocation_enabled = false
    display_name = "vcn-fw-interno"
    dns_label = "vcnfwinterno"
}