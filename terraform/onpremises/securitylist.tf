#
# onpremises/securitylist.tf
#

resource "oci_core_security_list" "secl-1_subnpub-internet_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "secl-1_subnpub-internet"

    egress_security_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = false
    }

    ingress_security_rules {
        source = "${var.meu_ip-publico}"
        protocol = "all"
        source_type = "CIDR_BLOCK"
        stateless = false
    }
}

resource "oci_core_security_list" "secl-1_subnprv-rede-app_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "secl-1_subnprv-rede-app"

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
}

resource "oci_core_security_list" "secl-1_subnprv-rede-backup_vcn-onpremises" {
    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.vcn-onpremises.id
    display_name = "secl-1_subnprv-rede-backup"

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
}
