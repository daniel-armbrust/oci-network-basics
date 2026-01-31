#
# vcn-fw-externo/securitylist.tf
#

resource "oci_core_security_list" "secl-1_subnprv-externo_vcn-fw-externo" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-fw-externo.id
    display_name = "secl-1_subnprv-1"

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