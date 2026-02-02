#
# vcn-fw-interno/output.tf
#

output "vcn_id" {
    value = oci_core_vcn.vcn-fw-interno.id
}

output "subnprv-1_id" {
    value = oci_core_subnet.subnprv-1.id
}

output "drg-attch_id" {
    value = oci_core_drg_attachment.drg-interno-attch_vcn-fw-interno.id
}