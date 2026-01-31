#
# vcn-fw-interno/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options_vcn-fw-interno" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    display_name = "dhcp-options_vcn-fw-interno"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}