#
# vcn-fw-interno/subnet.tf
#

# Sub-rede Privada LAN
resource "oci_core_subnet" "subnprv-appl_vcn-fw-interno" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-fw-interno.id
    route_table_id = oci_core_route_table.rt_subnprv-appl_vcn-fw-interno.id
    security_list_ids = [oci_core_security_list.secl-1_subnprv-appl_vcn-fw-interno.id]

    display_name = "subnprv-appl"
    dns_label = "subnprvappl"
    cidr_block = "${var.subnprv-appl_cidr}"
    ipv6cidr_block = "${var.subnprv-appl_ipv6_cidr}"

    prohibit_public_ip_on_vnic = true
}