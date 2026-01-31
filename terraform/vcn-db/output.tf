#
# vcn-db/output.tf
#

output "vcn_id" {
    value = oci_core_vcn.vcn-db.id
}

output "subnprv-1_id" {
    value = oci_core_subnet.subnprv-1_vcn-db.id
}