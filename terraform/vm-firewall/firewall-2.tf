#
# vm-firewall/firewall-2.tf
#

resource "oci_core_instance" "firewall-2" {
    compartment_id = var.root_compartment
    availability_domain = var.availability_domain    
    display_name = "firewall-2"

    shape = "VM.Standard.A1.Flex" 

    shape_config {
        baseline_ocpu_utilization = "BASELINE_1_1"
        memory_in_gbs = 4
        ocpus = 3
    }

    source_details {
        source_id = var.os_image_id
        source_type = "image"
        boot_volume_size_in_gbs = 100
    }  

    agent_config {
        is_management_disabled = false
        is_monitoring_disabled = false

        plugins_config {
            desired_state = "ENABLED"
            name = "Bastion"
        }
    }

    metadata = {
        ssh_authorized_keys = file("./ssh-keys/ssh-key.pub")
        user_data = base64encode(file("./vm-firewall/scripts/firewall-init.sh"))
    }

    extended_metadata = {       
       # Firewall #2 IPs
       "vnic-externo-ip" = "${var.firewall-2_externo-ip}"       
       "vnic-externo-ipv6" = "${var.firewall-2_externo-ipv6}"
       "vnic-appl-ip" = "${var.firewall-2_appl-ip}"
       "vnic-appl-ipv6" = "${var.firewall-2_appl-ipv6}"
       "vnic-internet-ip" = "${var.firewall-2_internet-ip}" 
       
       # VCN-FIREWALL-INTERNO 
       "vcn-fw-interno-cidr" = "${var.vcn-fw-interno_cidr}"
       "vcn-fw-interno-subnprv1-ip-gw" = "${var.vcn-fw-interno_subnprv-1_ip-gw}"
       "vcn-fw-interno-subnprv1-ipv6-gw" = "${var.vcn-fw-interno_subnprv-1_ipv6-gw}"
             
       # VCN-FIREWALL-EXTERNO
       "vcn-fw-externo-cidr" = "${var.vcn-fw-externo_cidr}"
       "vcn-fw-externo-subnprv1-ip-gw" = "${var.vcn-fw-externo_subnprv-1_ip-gw}"
       "vcn-fw-externo-subnprv1-ipv6-gw" = "${var.vcn-fw-externo_subnprv-1_ipv6-gw}"
       
       # VCN-APPL-1
       "vcn-appl-1-cidr" = "${var.vcn-appl-1_cidr}"
       "vcn-appl-1-ipv6-cidr" =  "${var.vcn-appl-1_ipv6_cidr}"

       # VCN-APPL-2
       "vcn-appl-2-cidr" = "${var.vcn-appl-2_cidr}"
       "vcn-appl-2-ipv6-cidr" = "${var.vcn-appl-2_ipv6_cidr}"

       # VCN-PUBLICA
       "vcn-publica-subnpub1-ip-gw" = "${var.vcn-publica_subnpub-1_ip-gw}"

       # On-Premises
       "onpremises-internet-cidr" = "${var.onpremises_internet_cidr}"
       "onpremises-rede-app-cidr" = "${var.onpremises_rede-app_cidr}"
       "onpremises-rede-backup-cidr" = "${var.onpremises_rede-backup_cidr}"         
    }

    # VNIC LAN
    create_vnic_details {
        display_name = "vnic-appl"
        hostname_label = "fw2"
        private_ip = "${var.firewall-2_appl-ip}"  
        subnet_id = "${var.vcn-fw-interno_subnprv-1_id}"
        skip_source_dest_check = true
        assign_public_ip = false

        assign_ipv6ip = true

        ipv6address_ipv6subnet_cidr_pair_details {
           ipv6subnet_cidr = "${var.vcn-fw-interno_subnprv-1_ipv6_cidr}"
           ipv6address = "${var.firewall-2_appl-ipv6}"
        }
    }
}

# VNIC Externa
resource "oci_core_vnic_attachment" "firewall-2_vnic-externo" {  
    display_name = "vnic-externo"
    instance_id = oci_core_instance.firewall-2.id
      
    create_vnic_details {    
        display_name = "vnic-externo"    
        hostname_label = "fw2ext"
        private_ip = "${var.firewall-2_externo-ip}"
        subnet_id = "${var.vcn-fw-externo_subnprv-1_id}"
        skip_source_dest_check = true
        assign_public_ip = false

        assign_ipv6ip = true

        ipv6address_ipv6subnet_cidr_pair_details {
           ipv6_subnet_cidr = "${var.vcn-fw-externo_subnprv-1_ipv6_cidr}"
           ipv6_address = "${var.firewall-2_externo-ipv6}"
        }
    }       

    depends_on = [
        oci_core_instance.firewall-2
    ]   
}

# VNIC INTERNET
resource "oci_core_vnic_attachment" "firewall-2_vnic-internet" {  
    display_name = "vnic-internet"
    instance_id = oci_core_instance.firewall-2.id
      
    create_vnic_details {    
        display_name = "vnic-internet"    
        hostname_label = "fw2int"
        private_ip = "${var.firewall-2_internet-ip}"               
        subnet_id = "${var.vcn-publica_subnpub-1_id}"
        skip_source_dest_check = true
        assign_public_ip = true
    }    

    depends_on = [
        oci_core_instance.firewall-2
    ]   
}