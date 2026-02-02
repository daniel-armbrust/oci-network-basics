#
# vcn-db/subnet.tf
#

# Sub-rede Privada #1 (subnprv-1)
resource "oci_core_subnet" "subnprv-1" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-db.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-db.id
    route_table_id = oci_core_route_table.rt_subnprv-1_vcn-db.id
    security_list_ids = [oci_core_security_list.secl-1_subnprv-1_vcn-db.id]

    display_name = "subnprv-1"
    dns_label = "subnprv1"
    cidr_block = "${var.subnprv_cidr}"
    ipv6cidr_block = "${var.subnprv_ipv6_cidr}"

    prohibit_public_ip_on_vnic = true
}