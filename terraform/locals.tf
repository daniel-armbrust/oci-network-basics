#
# locals.tf
#

locals {    
   # My Public IP Address
   meu_ip-publico = data.external.retora_meu_ip-publico.result.meu_ip-publico
   
   # VCN-APPL-1
   vcn-appl-1_cidr = "10.50.0.0/16"
   vcn-appl-1_subnprv-1_cidr = "10.50.10.0/24"
   vcn-appl-1_ipv6_cidr = "fd91:ab42:1200::/48"
   vcn-appl-1_subnprv-1_ipv6_cidr = "fd91:ab42:1200:10::/64"
   appl-1_ip = "10.50.10.10"  # Endereço IP da VM de Aplicação APPL-1
   appl-1_ipv6 = "fd91:ab42:1200:10::10" # Endereço IPv6 da VM de Aplicação APPL-1
   
   # VCN-APPL-2
   vcn-appl-2_cidr = "10.60.0.0/16"
   vcn-appl-2_subnprv-1_cidr = "10.60.10.0/24"
   vcn-appl-2_ipv6_cidr = "fd55:77cc:8d00::/48"
   vcn-appl-2_subnprv-1_ipv6_cidr = "fd55:77cc:8d00:10::/64"
   appl-2_ip = "10.60.10.10"  # Endereço IP da VM de Aplicação APPL-2
   appl-2_ipv6 = "fd55:77cc:8d00:10::10"  # Endereço IPv6 da VM de Aplicação APPL-2

   # VCN-DB
   vcn-db_cidr = "10.100.0.0/16"
   vcn-db_subnprv-1_cidr = "10.100.10.0/24"
   vcn-db_ipv6_cidr = "fd3f:9012:aa00::/48"
   vcn-db_subnprv-1_ipv6_cidr = "fd3f:9012:aa00:10::/64"
   db_ip = "10.100.10.50"  # Endereço IP do Banco de Dados
   db_ipv6 = "fd3f:9012:aa00:10::50"  # Endereço IPv6 do Banco de Dados

   # VCN-FW-INTERNO
   vcn-fw-interno_cidr = "10.70.0.0/16"
   vcn-fw-interno_subnprv-appl_cidr = "10.70.10.0/24"
   vcn-fw-interno_subnprv-appl_ip-gw = "10.70.10.1"
   vcn-fw-interno_ipv6_cidr = "fd82:44ee:f000::/48"
   vcn-fw-interno_subnprv-appl_ipv6_cidr = "fd82:44ee:f000:10::/64"
   vcn-fw-interno_subnprv-appl_ipv6-gw = "fd82:44ee:f000:10::1"
   
   # VCN-FW-EXTERNO
   vcn-fw-externo_cidr = "10.80.0.0/16"
   vcn-fw-externo_subnprv_cidr = "10.80.30.0/24"
   vcn-fw-externo_subnprv_ip-gw = "10.80.30.1"
   vcn-fw-externo_ipv6_cidr = "fd60:1a2b:9900::/48"
   vcn-fw-externo_subnprv_ipv6_cidr = "fd60:1a2b:9900:10::/64"
   vcn-fw-externo_subnprv_ipv6-gw = "fd60:1a2b:9900:10::1"

   # VCN-PUBLICA
   vcn-publica_cidr = "10.90.0.0/16"
   vcn-publica_subnpub-internet_cidr = "10.90.20.0/24"
   vcn-publica_subnpub-internet_ip-gw = "10.90.20.1"

   # Firewall #1 IPs
   firewall-1_appl-ip = "10.70.10.20"
   firewall-1_appl-ipv6 = "fd82:44ee:f000:10::20"
   firewall-1_internet-ip = "10.90.20.60"
   firewall-1_externo-ip = "10.80.30.40"
   firewall-1_externo-ipv6 = "fd60:1a2b:9900:10::40"
     
   # Firewall #2 IPs
   firewall-2_appl-ip = "10.70.10.21"
   firewall-2_appl-ipv6 = "fd82:44ee:f000:10::21"
   firewall-2_internet-ip = "10.90.20.80"
   firewall-2_externo-ip = "10.80.30.41"
   firewall-2_externo-ipv6 = "fd60:1a2b:9900:10::41"

   # Network Load Balancer do Firewall INTERNO
   nlb_fw-interno_ip = "10.70.10.100"
   nlb_fw-interno_ipv6 = "fd82:44ee:f000:10::100"

   # Network Load Balancer do Firewall EXTERNO
   nlb_fw-externo_ip = "10.80.30.100"
   nlb_fw-externo_ipv6 = "fd60:1a2b:9900:10::100"

   # VM-IPsec On-premises - VCNs
   vcn-onpremises_cidr = ["172.16.100.0/24", "10.200.10.0/24", "192.168.100.0/24"]
   
   # VM-IPSec On-Premises - Rede da Internet
   vcn-onpremises_internet-cidr = "172.16.100.0/25"
   vcn-onpremises_internet-ip = "172.16.100.5"
   vcn-onpremises_internet-ip-gw = "172.16.100.1"

   # VM-IPSec On-Premises - Rede das Aplicações
   vcn-onpremises_rede-app-cidr = "10.200.10.128/26"
   vcn-onpremises_rede-app-ip = "10.200.10.150"
   vcn-onpremises_rede-app-ip-gw = "10.200.10.129"

   # VM-IPSec On-Premises - Rede de Backup
   vcn-onpremises_rede-backup-cidr = "192.168.100.64/26"
   vcn-onpremises_rede-backup-ip = "192.168.100.120"
   vcn-onpremises_rede-backup-ip-gw = "192.168.100.65"

   # Site-To-Site VPN
   ipsec-onpremises_asn = "64515"
   ipsec-oracle_asn = "31898"

   ipsec_tunnel-1_bgp-local-ip = "192.168.0.1"
   ipsec_tunnel-1_bgp-local-ip-mask = "192.168.0.1/30"
   ipsec_tunnel-1_bgp-oci-ip = "192.168.0.2"
   ipsec_tunnel-1_bgp-oci-ip-mask = "192.168.0.2/30"
   ipsec_tunnel-1_bgp-cidr = "192.168.0.0/30"

   ipsec_tunnel-2_bgp-local-ip = "192.168.0.5"
   ipsec_tunnel-2_bgp-local-ip-mask = "192.168.0.5/30"
   ipsec_tunnel-2_bgp-oci-ip = "192.168.0.6"
   ipsec_tunnel-2_bgp-oci-ip-mask = "192.168.0.6/30"
   ipsec_tunnel-2_bgp-cidr = "192.168.0.4/30"

   # Service Gateway
   gru_all_oci_services = lookup(data.oci_core_services.gru_all_oci_services.services[0], "id")
   gru_oci_services_cidr_block = lookup(data.oci_core_services.gru_all_oci_services.services[0], "cidr_block")   
   
   # Region Names
   # See: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
   region_names = {
      "gru" = "sa-saopaulo-1"
   }

   # GRU Object Storage Namespace
   objectstorage_ns = data.oci_objectstorage_namespace.objectstorage_ns.namespace

   # Availability Domains
   ads = {
      gru_ad1_id = data.oci_identity_availability_domains.gru_ads.availability_domains[0].id
      gru_ad1_name = data.oci_identity_availability_domains.gru_ads.availability_domains[0].name
   }
 
   # Fault Domains
   fds = {
      gru_fd1_id = data.oci_identity_fault_domains.gru_fds.fault_domains[0].id,
      gru_fd1_name = data.oci_identity_fault_domains.gru_fds.fault_domains[0].name,

      gru_fd2_id = data.oci_identity_fault_domains.gru_fds.fault_domains[1].id,
      gru_fd2_name = data.oci_identity_fault_domains.gru_fds.fault_domains[1].name,

      gru_fd3_id = data.oci_identity_fault_domains.gru_fds.fault_domains[2].id,
      gru_fd3_name = data.oci_identity_fault_domains.gru_fds.fault_domains[2].name          
   }

   #
   # See: https://docs.oracle.com/en-us/iaas/images/
   #
   compute_image_id = {
      "gru" = {
         "ol96-arm" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaeiryb62ld5b2vrzqtf53zt5nbuwiv7d4nxuavggkfza5yjhqpfwa"
      }
   }
}