#
# vcn-fw-interno/output.tf
#

output "vcn_id" {
    value = oci_core_vcn.vcn-fw-interno.id
}

output "subnprv-appl_id" {
    value = oci_core_subnet.subnprv-appl_vcn-fw-interno.id
}

output "drg-attch_id" {
    value = oci_core_drg_attachment.drg-interno-attch_vcn-fw-interno.id
}