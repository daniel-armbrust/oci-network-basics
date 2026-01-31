#
# drg-externo.tf
#

resource "oci_core_drg" "drg-externo" { 
    compartment_id = var.root_compartment
    display_name = "drg-externo"   
}