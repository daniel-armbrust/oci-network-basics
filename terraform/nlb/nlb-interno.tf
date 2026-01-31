#
# nlb/nlb-interno.tf
#

resource "oci_network_load_balancer_network_load_balancer" "nlb_fw-interno" {
    compartment_id = var.root_compartment

    display_name = "nlb_fw-interno"    
    assigned_private_ipv4 = var.nlb_fw-interno_ip
    subnet_id = var.fw-interno_subnet_id       
    
    is_private = true
    is_preserve_source_destination = true
    is_symmetric_hash_enabled = true
}

resource "oci_network_load_balancer_listener" "nlb_fw-interno_listener" {
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_fw-interno.id

    name = "fw-interno_listener"
    default_backend_set_name = "fw-interno_backendset"

    ip_version = "IPV4"
    protocol = "ANY"
    port = 0

    depends_on = [
        oci_network_load_balancer_backend_set.nlb_fw-interno_backend_set
    ]
}

resource "oci_network_load_balancer_backend_set" "nlb_fw-interno_backend_set" {
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_fw-interno.id
    
    name = "fw-interno_backendset"
    ip_version = "IPV4"
    is_preserve_source = false
    is_instant_failover_enabled = true
    policy = "TWO_TUPLE"

    health_checker {
       protocol = "TCP"
       port = 22
    }  
}

resource "oci_network_load_balancer_backend" "nlb_fw-interno-1" {
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_fw-interno.id
    
    backend_set_name = "fw-interno_backendset"    

    name = "firewall-1"
    ip_address = var.firewall-1_appl-ip
    port = 0
    is_backup = false
    is_drain = false
    is_offline = false
    weight = 1

    depends_on = [
        oci_network_load_balancer_backend_set.nlb_fw-interno_backend_set
    ]
}

resource "oci_network_load_balancer_backend" "nlb_fw-interno-2" {
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_fw-interno.id
    
    backend_set_name = "fw-interno_backendset"    

    name = "firewall-2"
    ip_address = var.firewall-2_appl-ip
    port = 0
    is_backup = false
    is_drain = false
    is_offline = false
    weight = 1

    depends_on = [
        oci_network_load_balancer_backend_set.nlb_fw-interno_backend_set
    ]
}