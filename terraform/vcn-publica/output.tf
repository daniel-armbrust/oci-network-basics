#
# vcn-publica/output.tf
#

output "vcn_id" {
    value = oci_core_vcn.vcn-publica.id
}

output "subnpub-internet_id" {
    value = oci_core_subnet.subnpub-internet_vcn-publica.id
}