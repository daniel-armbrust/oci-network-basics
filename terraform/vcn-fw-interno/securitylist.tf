#
# vcn-fw-interno/securitylist.tf
#

# Security List #1 - Sub-rede Privada Appl
resource "oci_core_security_list" "secl-1_subnprv-appl_vcn-fw-interno" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-interno.id
    display_name = "secl-1_subnprv-appl"

    # IPv4
    egress_security_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = true
    }

    ingress_security_rules {
        source = "0.0.0.0/0"
        protocol = "all"
        source_type = "CIDR_BLOCK"
        stateless = true
    }

    # IPv6
    egress_security_rules {
        destination = "::/0"
        destination_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = true
    }

    ingress_security_rules {
        source = "::/0"
        source_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = true
    }
}