#
# onpremises/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "dhcp-options_vcn-onpremises"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}