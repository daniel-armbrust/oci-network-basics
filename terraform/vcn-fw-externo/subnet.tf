#
# vcn-fw-externo/subnet.tf
#

# Sub-rede Privada #1 (subnprv-1)
resource "oci_core_subnet" "subnprv-externo_vcn-fw-externo" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-externo.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-fw-externo.id
    route_table_id = oci_core_route_table.rt_subnprv-externo_vcn-fw-externo.id
    security_list_ids = [oci_core_security_list.secl-1_subnprv-externo_vcn-fw-externo.id]

    display_name = "subnprv-externo"
    dns_label = "subnprvext"
    cidr_block = "${var.subnprv-externo_cidr}"
    ipv6cidr_block = "${var.subnprv-externo_ipv6_cidr}"

    prohibit_public_ip_on_vnic = true
}