#
# vcn-appl-1/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-appl-1.id
    display_name = "dhcp-options"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}