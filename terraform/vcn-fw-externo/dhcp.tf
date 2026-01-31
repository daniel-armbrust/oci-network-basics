#
# vcn-fw-externo/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options_vcn-fw-externo" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-externo.id
    display_name = "dhcp-options_vcn-fw-externo"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}