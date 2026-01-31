#
# objectstorage.tf
#


resource "oci_objectstorage_bucket" "objectstorage_bucket" {
    compartment_id = var.root_compartment
    namespace = local.objectstorage_ns
    name = "scripts-storage"
    access_type = "NoPublicAccess"
    versioning = "Disabled"
}

resource "oci_objectstorage_object" "objectstorage_file_vm-firewall_rc-firewal" {
    bucket = "scripts-storage"
    namespace = local.objectstorage_ns    
       
    object = "vm-firewall_rc-firewal.sh"
    source = "./vm-firewall/scripts/rc-firewall.sh"
    content_type = "text/plain"

    depends_on = [
        oci_objectstorage_bucket.objectstorage_bucket
    ]  
}

resource "oci_objectstorage_object" "objectstorage_file_onpremises_vm-ipsec_ip-public-setup" {
    bucket = "scripts-storage"
    namespace = local.objectstorage_ns    
       
    object = "ip-public-setup.sh"
    source = "./onpremises/scripts/ip-public-setup.sh"
    content_type = "text/plain"

    depends_on = [
        oci_objectstorage_bucket.objectstorage_bucket
    ]  
}

resource "oci_objectstorage_object" "objectstorage_file_onpremises_vm-ipsec_rc-firewall" {
    bucket = "scripts-storage"
    namespace = local.objectstorage_ns    
       
    object = "rc-firewall-vm-ipsec-onpremises.sh"
    source = "./onpremises/scripts/rc-firewall.sh"
    content_type = "text/plain"

    depends_on = [
        oci_objectstorage_bucket.objectstorage_bucket
    ]  
}

resource "oci_objectstorage_object" "objectstorage_file_onpremises_vm-ipsec_vpn-setup" {
    bucket = "scripts-storage"
    namespace = local.objectstorage_ns    
       
    object = "vpn-setup.sh"
    source = "./onpremises/scripts/vpn-setup.sh"
    content_type = "text/plain"

    depends_on = [
        oci_objectstorage_bucket.objectstorage_bucket
    ]  
}

resource "oci_objectstorage_object" "objectstorage_file_onpremises_vm-ipsec_bgp-setup" {
    bucket = "scripts-storage"
    namespace = local.objectstorage_ns    
       
    object = "bgp-setup.sh"
    source = "./onpremises/scripts/bgp-setup.sh"
    content_type = "text/plain"

    depends_on = [
        oci_objectstorage_bucket.objectstorage_bucket
    ]  
}