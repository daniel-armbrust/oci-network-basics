#
# vcn-publica/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options_vcn-publica" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-publica.id
    display_name = "dhcp-options_vcn-publica"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}