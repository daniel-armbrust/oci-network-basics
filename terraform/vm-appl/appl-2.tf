#
# vm-appl/appl-2.tf
#

resource "oci_core_instance" "appl-2" {
    compartment_id = var.root_compartment
    availability_domain = var.availability_domain    
    display_name = "appl-2"

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
        user_data = base64encode(file("./vm-appl/scripts/appl-2-init.sh"))
    }

    create_vnic_details {
        display_name = "vnic_appl-2"
        hostname_label = "appl2"
        private_ip = var.appl-2_ip
        subnet_id = var.appl-2_subnprv_id
        skip_source_dest_check = false
        assign_public_ip = false
        assign_ipv6ip = false
    }
}