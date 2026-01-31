#
# vcn-appl-1/output.tf
#

output "vcn_id" {
    value = oci_core_vcn.vcn-appl-1.id
}

output "subnprv-1_id" {
    value = oci_core_subnet.subnprv-1_vcn-appl-1.id
}

output "drg-attch_id" {
    value = oci_core_drg_attachment.drg-interno-attch_vcn-appl-1.id
}

output "lpg_id" {
    value = oci_core_local_peering_gateway.lpg_vcn-appl-1_vcn-db.id
}