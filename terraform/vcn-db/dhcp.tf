#
# vcn-db/dhcp.tf
#

# Dhcp Options
resource "oci_core_dhcp_options" "dhcp-options_vcn-db" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-db.id
    display_name = "dhcp-options_vcn-db"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}