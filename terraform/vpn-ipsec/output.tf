#
# vpn-ipsec/output.tf
#

data "oci_core_ipsec_connection_tunnels" "onpremises_ipsec_tunnels" {
   ipsec_id = oci_core_ipsec.onpremises_ipsec.id
}

data "oci_core_ipsec_config" "onpremises_ipsec_config" {
    ipsec_id = oci_core_ipsec.onpremises_ipsec.id
}

data "oci_core_ipsec_connection_tunnel" "onpremises_ipsec_tunnel-1" {
    ipsec_id = oci_core_ipsec.onpremises_ipsec.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.onpremises_ipsec_tunnels.ip_sec_connection_tunnels[0].id
}

data "oci_core_ipsec_connection_tunnel" "onpremises_ipsec_tunnel-2" {
    ipsec_id = oci_core_ipsec.onpremises_ipsec.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.onpremises_ipsec_tunnels.ip_sec_connection_tunnels[1].id
}

#-----------#
# Tunnel #1 #
#-----------#

output "tunnel-1_shared-secret" {
   value = data.oci_core_ipsec_config.onpremises_ipsec_config.tunnels[0].shared_secret 
   sensitive = true
}

output "tunnel-1_public-ip" {
   value = data.oci_core_ipsec_config.onpremises_ipsec_config.tunnels[0].ip_address 
}

#-----------#
# Tunnel #2 #
#-----------#

output "tunnel-2_shared-secret" {
   value = data.oci_core_ipsec_config.onpremises_ipsec_config.tunnels[1].shared_secret
   sensitive = true
}

output "tunnel-2_public-ip" {
   value = data.oci_core_ipsec_config.onpremises_ipsec_config.tunnels[1].ip_address 
}