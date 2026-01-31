#
# reserved-public-ip/output.tf
#

output "reserved-public-ip_id" {
    value = oci_core_public_ip.reserved-public-ip.id
}

output "reserved-public-ip" {
    value = oci_core_public_ip.reserved-public-ip.ip_address
}