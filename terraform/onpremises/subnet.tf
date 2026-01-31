#
# onpremises/subnet.tf
#

# Sub-rede Publica INTERNET
resource "oci_core_subnet" "subnpub-internet_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-onpremises.id
    route_table_id = oci_core_route_table.rt_subnpub-internet_vcn-onpremises.id
    security_list_ids = [oci_core_security_list.secl-1_subnpub-internet_vcn-onpremises.id]

    display_name = "subnpub-internet"
    dns_label = "onpsubnpubinet"
    cidr_block = "${var.vm-ipsec_internet_cidr}"
    prohibit_public_ip_on_vnic = false
}

# Sub-rede Privada das Aplicações
resource "oci_core_subnet" "subnprv-rede-app_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-onpremises.id
    route_table_id = oci_core_route_table.rt_subnprv-rede-app_vcn-onpremises.id
    security_list_ids = [oci_core_security_list.secl-1_subnpub-internet_vcn-onpremises.id]

    display_name = "subnprv-rede-app"
    dns_label = "onpsubnprvapp"
    cidr_block = "${var.vm-ipsec_rede-app_cidr}"
    prohibit_public_ip_on_vnic = true
}

# Sub-rede Privada de Backup
resource "oci_core_subnet" "subnprv-rede-backup_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    dhcp_options_id = oci_core_dhcp_options.dhcp-options_vcn-onpremises.id
    route_table_id = oci_core_route_table.rt_subnprv-rede-backup_vcn-onpremises.id
    security_list_ids = [oci_core_security_list.secl-1_subnprv-rede-backup_vcn-onpremises.id]

    display_name = "subnprv-rede-backup"
    dns_label = "onpsubnprvbkp"
    cidr_block = "${var.vm-ipsec_rede-backup_cidr}"
    prohibit_public_ip_on_vnic = true
}