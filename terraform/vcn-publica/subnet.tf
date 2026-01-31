#
# vcn-publica/subnet.tf
#

# Sub-rede Publica #1 (subnpub-1)
resource "oci_core_subnet" "subnpub-internet_vcn-publica" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-publica.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-publica.id
    route_table_id = oci_core_route_table.rt_subnpub-internet_vcn-publica.id
    security_list_ids = [oci_core_security_list.secl-1_subnpub-internet_vcn-publica.id]

    display_name = "subnpub-internet"
    dns_label = "subnpubinet"
    cidr_block = "${var.subnpub-internet_cidr}"
    
    prohibit_public_ip_on_vnic = false
}