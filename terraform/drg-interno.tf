#
# drg-interno.tf
#

resource "oci_core_drg" "drg-interno" { 
    compartment_id = var.root_compartment
    display_name = "drg-interno"   
}