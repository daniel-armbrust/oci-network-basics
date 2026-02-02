#
# main.tf
#

# VCN de Aplicação #1 (vcn-appl-1)
module "vcn-appl-1" {
    source = "./vcn-appl-1"
    root_compartment = var.root_compartment

    # IPv4
    vcn_cidr = local.vcn-appl-1_cidr    
    subnprv_cidr = local.vcn-appl-1_subnprv-1_cidr
    
    # IPv6
    vcn_ipv6_cidr = local.vcn-appl-1_ipv6_cidr
    subnprv_ipv6_cidr = local.vcn-appl-1_subnprv-1_ipv6_cidr

    # On-Premises - Rede das Aplicações.
    onpremises_rede-app_cidr = local.vcn-onpremises_rede-app-cidr
    
    # DRG, Attachments
    vcn-appl-2_drg-attch_id = module.vcn-appl-2.drg-attch_id
    vcn-fw-interno_drg-attch_id = module.vcn-fw-interno.drg-attch_id
    drg_id = oci_core_drg.drg-interno.id
    drg-interno_rpc_id = "${data.oci_core_drg_attachments.drg-interno_rpc-attch.drg_attachments[0].id}"
    drg-interno-attch_vcn-fw-interno_id = "${data.oci_core_drg_attachments.drg-interno-attch_vcn-fw-interno.drg_attachments[0].id}"

    # Service Gateway (ALL SERVICES GRU)
    sgw_all_oci_services = local.gru_all_oci_services    
}

# VCN de Aplicação #2 (vcn-appl-2)
module "vcn-appl-2" {
    source = "./vcn-appl-2"
    root_compartment = var.root_compartment

    # IPv4
    vcn_cidr = local.vcn-appl-2_cidr
    subnprv_cidr = local.vcn-appl-2_subnprv-1_cidr

    # IPv6
    vcn_ipv6_cidr = local.vcn-appl-2_ipv6_cidr
    subnprv_ipv6_cidr = local.vcn-appl-2_subnprv-1_ipv6_cidr

    # DRG, Attachments
    vcn-appl-1_drg-attch_id = module.vcn-appl-1.drg-attch_id
    vcn-fw-interno_drg-attch_id = module.vcn-fw-interno.drg-attch_id
    drg_id = oci_core_drg.drg-interno.id
    drg-interno-attch_vcn-fw-interno_id = "${data.oci_core_drg_attachments.drg-interno-attch_vcn-fw-interno.drg_attachments[0].id}"

    # Service Gateway (ALL SERVICES GRU)
    sgw_all_oci_services = local.gru_all_oci_services  
}

# VCN Publica (vcn-publica)
module "vcn-publica" {
    source = "./vcn-publica"
    root_compartment = var.root_compartment

    # IPv4
    vcn_cidr = local.vcn-publica_cidr
    subnpub-1_cidr = local.vcn-publica_subnpub-1_cidr

    # Meu endereço IP Publico.
    meu_ip-publico = local.meu_ip-publico 
}

# VCN do Banco de Dados (vcn-db)
module "vcn-db" {
    source = "./vcn-db"
    root_compartment = var.root_compartment

    # IPv4
    vcn_cidr = local.vcn-db_cidr
    subnprv_cidr = local.vcn-db_subnprv-1_cidr
    
    # IPv6
    vcn_ipv6_cidr = local.vcn-db_ipv6_cidr
    subnprv_ipv6_cidr = local.vcn-db_subnprv-1_ipv6_cidr

    # Local Peering Gateway
    lpg_vcn-appl-1_id = module.vcn-appl-1.lpg_id
    lpg_vcn-appl-2_id = module.vcn-appl-2.lpg_id

    # Service Gateway (ALL SERVICES GRU)
    sgw_all_oci_services = local.gru_all_oci_services
}

# VCN do Firewall Interno (vcn-fw-interno)
module "vcn-fw-interno" {
    source = "./vcn-fw-interno"
    root_compartment = var.root_compartment

    # IPv4
    vcn_cidr = local.vcn-fw-interno_cidr
    subnprv-1_cidr = local.vcn-fw-interno_subnprv-1_cidr

    # IPv6
    vcn_ipv6_cidr = local.vcn-fw-interno_ipv6_cidr
    subnprv-1_ipv6_cidr = local.vcn-fw-interno_subnprv-1_ipv6_cidr
    
    # DRG, Attachments
    vcn-appl-1_drg-attch_id = module.vcn-appl-1.drg-attch_id
    vcn-appl-2_drg-attch_id = module.vcn-appl-2.drg-attch_id    
    drg_id = oci_core_drg.drg-interno.id
    
    # OCID do Endereço IP do Network Load Balancer do Firewall Interno.
    nlb_fw-interno_ip_id = module.nlb.nlb_fw-interno_private-ip_id

    # Service Gateway (ALL SERVICES GRU)
    sgw_all_oci_services = local.gru_all_oci_services
}

# VCN do Firewall Externo (vcn-fw-externo)
module "vcn-fw-externo" {
    source = "./vcn-fw-externo"
    root_compartment = var.root_compartment

    # IPv4
    vcn_cidr = local.vcn-fw-externo_cidr
    subnprv-1_cidr = local.vcn-fw-externo_subnprv-1_cidr
    vcn-appl-1_cidr = local.vcn-appl-1_cidr
    vcn-appl-2_cidr = local.vcn-appl-2_cidr
    
    # IPv6
    vcn_ipv6_cidr = local.vcn-fw-externo_ipv6_cidr
    subnprv-1_ipv6_cidr = local.vcn-fw-externo_subnprv-1_ipv6_cidr
    vcn-appl-1_ipv6_cidr = local.vcn-appl-1_ipv6_cidr
    vcn-appl-2_ipv6_cidr = local.vcn-appl-2_ipv6_cidr

    # DRG, Attachments
    drg_id = oci_core_drg.drg-externo.id
    sgw_all_oci_services = local.gru_all_oci_services

    # OCID do Endereço IP do Network Load Balancer do Firewall Externo.
    nlb_fw-externo_ip_id = module.nlb.nlb_fw-externo_private-ip_id   
}

# Network Load Balancers
module "nlb" {
    source = "./nlb"
    root_compartment = var.root_compartment

    nlb_fw-interno_ip = local.nlb_fw-interno_ip
    nlb_fw-externo_ip = local.nlb_fw-externo_ip

    fw-interno_subnet_id = module.vcn-fw-interno.subnprv-1_id
    fw-externo_subnet_id = module.vcn-fw-externo.subnprv-1_id
       
    # Firewall #1
    firewall-1_appl-ip = local.firewall-1_appl-ip 
    firewall-1_externo-ip = local.firewall-1_externo-ip

    # Firewall #2
    firewall-2_appl-ip = local.firewall-2_appl-ip
    firewall-2_externo-ip = local.firewall-2_externo-ip
}

module "vm-firewall" {
    source = "./vm-firewall"
    root_compartment = var.root_compartment    

    # Availability Domain (GRU)
    availability_domain = local.ads.gru_ad1_name

    # Oracle Linux Image ID (GRU)
    os_image_id = local.compute_image_id.gru.ol96-arm

    #----------------#
    # VCN-FW-INTERNO #
    #----------------#

    # IPv4
    vcn-fw-interno_cidr = local.vcn-fw-interno_cidr
    vcn-fw-interno_subnprv-1_ip-gw = local.vcn-fw-interno_subnprv-1_ip-gw

    # IPv6
    vcn-fw-interno_ipv6_cidr = local.vcn-fw-interno_ipv6_cidr
    vcn-fw-interno_subnprv-1_ipv6_cidr = local.vcn-fw-interno_subnprv-1_ipv6_cidr
    vcn-fw-interno_subnprv-1_ipv6-gw = local.vcn-fw-interno_subnprv-1_ipv6-gw
    
    # OCID da Sub-rede privada da VCN-FIREWALL-INTERNO
    vcn-fw-interno_subnprv-1_id = module.vcn-fw-interno.subnprv-1_id

    #----------------#
    # VCN-FW-EXTERNO #
    #----------------#
    
    # IPv4
    vcn-fw-externo_cidr = local.vcn-fw-externo_cidr
    vcn-fw-externo_subnprv-1_ip-gw = local.vcn-fw-externo_subnprv-1_ip-gw
    
    # IPv6
    vcn-fw-externo_ipv6_cidr = local.vcn-fw-externo_ipv6_cidr
    vcn-fw-externo_subnprv-1_ipv6_cidr = local.vcn-fw-externo_subnprv-1_ipv6_cidr
    vcn-fw-externo_subnprv-1_ipv6-gw = local.vcn-fw-externo_subnprv-1_ipv6-gw

    # OCID da Sub-rede privada da VCN-FIREWALL-EXTERNO
    vcn-fw-externo_subnprv-1_id = module.vcn-fw-externo.subnprv-1_id

    #-------------#
    # VCN-PUBLICA #
    #-------------#

    # IPv4
    vcn-publica_subnpub-1_ip-gw = local.vcn-publica_subnpub-1_ip-gw
    vcn-publica_subnpub-1_id = module.vcn-publica.subnpub-1_id
        
    #------------#
    # VCN-APPL-1 #
    #------------#

    # IPv4
    vcn-appl-1_cidr = local.vcn-appl-1_cidr
    
    # IPv6
    vcn-appl-1_ipv6_cidr = local.vcn-appl-1_ipv6_cidr

    #------------#
    # VCN-APPL-2 #
    #------------#

    # IPv4
    vcn-appl-2_cidr = local.vcn-appl-2_cidr 

    # IPv6
    vcn-appl-2_ipv6_cidr = local.vcn-appl-2_ipv6_cidr

    #---------------------#
    # FIREWALL INTERNO #1 #
    #---------------------#

    # IPv4
    firewall-1_appl-ip = local.firewall-1_appl-ip    
    firewall-1_externo-ip = local.firewall-1_externo-ip  
    firewall-1_internet-ip = local.firewall-1_internet-ip   

    # IPv6   
    firewall-1_appl-ipv6 = local.firewall-1_appl-ipv6   
    firewall-1_externo-ipv6 = local.firewall-1_externo-ipv6
    
    #---------------------#
    # FIREWALL INTERNO #2 #
    #---------------------#

    # IPv4
    firewall-2_appl-ip = local.firewall-2_appl-ip    
    firewall-2_externo-ip = local.firewall-2_externo-ip 
    firewall-2_internet-ip = local.firewall-2_internet-ip   

    # IPv6   
    firewall-2_appl-ipv6 = local.firewall-2_appl-ipv6   
    firewall-2_externo-ipv6 = local.firewall-2_externo-ipv6

    # On-premises
    onpremises_internet_cidr = local.vcn-onpremises_internet-cidr
    onpremises_rede-app_cidr = local.vcn-onpremises_rede-app-cidr
    onpremises_rede-backup_cidr = local.vcn-onpremises_rede-backup-cidr
}

module "vm-appl" {
    source = "./vm-appl"
    root_compartment = var.root_compartment    
    availability_domain = local.ads.gru_ad1_name
    os_image_id = local.compute_image_id.gru.ol96-arm

    # Endereço IP e Sub-rede ID da VM de Aplicação APPL-1
    appl-1_ip = local.appl-1_ip
    appl-1_subnprv_id = module.vcn-appl-1.subnprv-1_id

    # Endereço IP e Sub-rede ID da VM de Aplicação APPL-2
    appl-2_ip = local.appl-2_ip
    appl-2_subnprv_id = module.vcn-appl-2.subnprv-1_id
}

# Reserva da Endereço IP Publico
module "reserved-public-ip" {
    source = "./reserved-public-ip"
    root_compartment = var.root_compartment
}

module "vpn-ipsec" {
    source = "./vpn-ipsec"
    root_compartment = var.root_compartment
    drg_id = oci_core_drg.drg-externo.id

    # Endereço IP Público do CPE (vm-ipsec-onpremises)
    cpe_ip = module.reserved-public-ip.reserved-public-ip
    cpe_private-ip = local.vcn-onpremises_internet-ip
    
    # On-premises BGP ASN
    ipsec-onpremises_asn = local.ipsec-onpremises_asn

    # Site-To-Site VPN - Tunnel #1
    ipsec_tunnel-1_bgp-local-ip-mask = local.ipsec_tunnel-1_bgp-local-ip-mask
    ipsec_tunnel-1_bgp-oci-ip-mask = local.ipsec_tunnel-1_bgp-oci-ip-mask
 
    # Site-To-Site VPN - Tunnel #2
    ipsec_tunnel-2_bgp-local-ip-mask = local.ipsec_tunnel-2_bgp-local-ip-mask
    ipsec_tunnel-2_bgp-oci-ip-mask = local.ipsec_tunnel-2_bgp-oci-ip-mask

    # VCN-FW-EXTERNO - DRG Attachment
    # NOTA: O IPSec "aprende" somente as redes da VCN-FW-EXTERNO. Essa configuração é necessária
    # para direcionar todo o tráfego que vem do IPSec para o Firewall.
    # (não é possível trabalhar com rotas estáticas uma vez que o IPSec on-premises utiliza BGP).
    vcn-fw-externo_drg-attch_id = module.vcn-fw-externo.drg-attch_id
}

# On-Premises
module "onpremises" {
    source = "./onpremises"
    root_compartment = var.root_compartment

    availability_domain = local.ads.gru_ad1_name
    os_image_id = local.compute_image_id.gru.ol96-arm
    sgw_all_oci_services = local.gru_all_oci_services

    # VM IPsec - VCN
    vcn_cidr = local.vcn-onpremises_cidr

    # IP Público Reservado
    reserved-public-ip_id = module.reserved-public-ip.reserved-public-ip_id

    # VM IPSec - IP
    vm-ipsec_internet_cidr = local.vcn-onpremises_internet-cidr
    vm-ipsec_internet-ip = local.vcn-onpremises_internet-ip
    vm-ipsec_internet-ip-gw = local.vcn-onpremises_internet-ip-gw
    
    # VM IPSec - Rede das Aplicações
    vm-ipsec_rede-app_cidr = local.vcn-onpremises_rede-app-cidr
    vm-ipsec_rede-app-ip = local.vcn-onpremises_rede-app-ip
    vm-ipsec_rede-app-ip-gw = local.vcn-onpremises_rede-app-ip-gw

    # VM IPSec - Rede de Backup
    vm-ipsec_rede-backup_cidr = local.vcn-onpremises_rede-backup-cidr
    vm-ipsec_rede-backup-ip = local.vcn-onpremises_rede-backup-ip
    vm-ipsec_rede-backup-ip-gw = local.vcn-onpremises_rede-backup-ip-gw

    # VM IPSec - Endereço IP Público Reservado
    vm-ipsec_public-ip = module.reserved-public-ip.reserved-public-ip
    vm-ipsec_public-ip_id = module.reserved-public-ip.reserved-public-ip_id

    # VM IPsec - BGP ASN
    ipsec-onpremises_asn = local.ipsec-onpremises_asn
    ipsec_oracle_asn = local.ipsec-oracle_asn
 
    # VM IPSec - Tunnel #1
    ipsec_tunnel-1_bgp-local-ip = local.ipsec_tunnel-1_bgp-local-ip
    ipsec_tunnel-1_bgp-local-ip-mask = local.ipsec_tunnel-1_bgp-local-ip-mask
    ipsec_tunnel-1_bgp-oci-ip = local.ipsec_tunnel-1_bgp-oci-ip
    ipsec_tunnel-1_bgp-oci-ip-mask = local.ipsec_tunnel-1_bgp-oci-ip-mask
    ipsec_tunnel-1_bgp-cidr = local.ipsec_tunnel-1_bgp-cidr
    ipsec_tunnel-1_bgp-oci-public-ip = module.vpn-ipsec.tunnel-1_public-ip
    ipsec_tunnel-1_shared-secret = module.vpn-ipsec.tunnel-1_shared-secret
    
    # VM IPSec - Tunnel #2
    ipsec_tunnel-2_bgp-local-ip = local.ipsec_tunnel-2_bgp-local-ip
    ipsec_tunnel-2_bgp-local-ip-mask = local.ipsec_tunnel-2_bgp-local-ip-mask
    ipsec_tunnel-2_bgp-oci-ip = local.ipsec_tunnel-2_bgp-oci-ip
    ipsec_tunnel-2_bgp-oci-ip-mask = local.ipsec_tunnel-2_bgp-oci-ip-mask
    ipsec_tunnel-2_bgp-cidr = local.ipsec_tunnel-2_bgp-cidr
    ipsec_tunnel-2_bgp-oci-public-ip = module.vpn-ipsec.tunnel-2_public-ip
    ipsec_tunnel-2_shared-secret = module.vpn-ipsec.tunnel-2_shared-secret
    
    # Meu endereço IP Publico.
    meu_ip-publico = local.meu_ip-publico 
}