#
# vcn-fw-externo/output.tf
#

output "vcn_id" {
    value = oci_core_vcn.vcn-fw-externo.id
}

output "subnprv-1_id" {
    value = oci_core_subnet.subnprv-1.id
}

output "drg-attch_id" {
    value = oci_core_drg_attachment.drg-externo-attch_vcn-fw-externo.id
}