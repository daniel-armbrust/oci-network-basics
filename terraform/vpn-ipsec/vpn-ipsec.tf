#
# vpn-ipsec/vpn-ipsec.tf
#

resource "oci_core_cpe" "cpe_vm-ipsec_onpremises" {
    compartment_id = var.root_compartment
    display_name = "cpe_vm-ipsec_onpremises"
    ip_address = var.cpe_ip
}

resource "oci_core_ipsec" "onpremises_ipsec" {
    compartment_id = var.root_compartment    
    drg_id = var.drg_id
    display_name = "onpremises_ipsec"

    # Vazio para roteamento através de BGP.
    static_routes = ["0.0.0.0/0"]

    cpe_id = oci_core_cpe.cpe_vm-ipsec_onpremises.id
    cpe_local_identifier = var.cpe_private-ip
}

resource "oci_core_ipsec_connection_tunnel_management" "onpremises_ipsec_tunnel-1" {
    display_name = "tunnel-1"

    ipsec_id = oci_core_ipsec.onpremises_ipsec.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.onpremises_ipsec_tunnels.ip_sec_connection_tunnels[0].id
    ike_version = "V2"

    routing = "BGP"

    bgp_session_info {
        customer_bgp_asn = var.ipsec-onpremises_asn
        customer_interface_ip = var.ipsec_tunnel-1_bgp-local-ip-mask
        oracle_interface_ip = var.ipsec_tunnel-1_bgp-oci-ip-mask
    }
}

resource "oci_core_ipsec_connection_tunnel_management" "onpremises_ipsec_tunnel-2" {
    display_name = "tunnel-2"

    ipsec_id = oci_core_ipsec.onpremises_ipsec.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.onpremises_ipsec_tunnels.ip_sec_connection_tunnels[1].id
    ike_version = "V2"

    routing = "BGP"

    bgp_session_info {
        customer_bgp_asn = var.ipsec-onpremises_asn
        customer_interface_ip = var.ipsec_tunnel-2_bgp-local-ip-mask
        oracle_interface_ip = var.ipsec_tunnel-2_bgp-oci-ip-mask
    }
}