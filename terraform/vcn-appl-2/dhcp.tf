#
# vcn-appl-2/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options_vcn-appl-2" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-appl-2.id
    display_name = "dhcp-options_vcn-appl-2"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}