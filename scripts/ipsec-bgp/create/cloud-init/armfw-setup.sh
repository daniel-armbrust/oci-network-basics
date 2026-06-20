#!/bin/bash

#---------#
# OCI CLI #
#---------#
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" -- \
     --accept-all-defaults

#-------------------#
# ArmFirewall Setup #
#-------------------#
dnf -y install git

lan_iface="$(ip route | grep default | awk '{print $5}' | head -1)"

cd /opt && git clone https://github.com/daniel-armbrust/armfirewall-proj.git
cd armfirewall-proj/bin && ./install.sh --lan-iface "$lan_iface"

#-------------------#
# IPs Data Download #
#-------------------#
/root/bin/oci os object get --bucket-name armfw-data --name armfw-data.txt \
    --file /tmp/armfw-data.txt --auth instance_principal

#------------------------#
# Libreswan/Bird Service #
#------------------------#
./services.sh install libreswan
./services.sh install bird

./services.sh start libreswan

#----------------#
# Firewall Rules #
#----------------#
./firewall.sh filter add --chain INPUT --protocol-name udp --dst-port 500 \
    --action ACCEPT --conntrack-mode new

# RIP
./firewall.sh filter add --chain INPUT --protocol-name udp --dst-port 520 \
    --action ACCEPT --conntrack-mode new

./firewall.sh filter add --chain INPUT --protocol-name udp --dst-port 4500 \
    --action ACCEPT --conntrack-mode new

./firewall.sh filter add --chain INPUT --protocol-name esp --action ACCEPT

./firewall.sh filter add --chain INPUT --src-addr 10.255.255.0/24 --protocol-name all \
    --action ACCEPT

./firewall.sh filter add --chain FORWARD --src-addr 10.255.255.0/24 \
    --protocol-name all --action ACCEPT

./firewall.sh filter add --chain FORWARD --dst-addr 10.255.255.0/24 \
    --protocol-name all --action ACCEPT

#-------#
# IPSec #
#-------#
my_hostname="$(hostname)"
my_prv_ip="$(hostname -I)"
my_pub_ip="$(grep "$my_hostname" /tmp/armfw-data.txt | cut -f2 -d ':')"
bgp_asn="$(cat /tmp/armfw-data.txt | grep "BGP_ASN" | cut -f2 -d ':')"

# Tunnel-1
vti_1_ip_mask="$(cat /tmp/armfw-data.txt | grep "IPSEC_BGP_1_IP" | cut -f2 -d ':')"
oci_1_ip_mask="$(cat /tmp/armfw-data.txt | grep "IPSEC_BGP_1_IP" | cut -f3 -d ':')"
tunnel_1_pub_ip="$(cat /tmp/armfw-data.txt | grep "TUNNEL_1" | cut -f2 -d ':')"
tunnel_1_psk="$(cat /tmp/armfw-data.txt | grep "TUNNEL_1" | cut -f3 -d ':')"

./libreswan.sh add \
    --conn-name "oci-1" \
    --left "$my_prv_ip" \
    --left-id "$my_prv_ip" \
    --right "$tunnel_1_pub_ip" \
    --shared-secret "$tunnel_1_psk" \
    --ikev2 insist \
    --ike "aes_cbc256-sha2_384;modp1536" \
    --phase2alg "aes256-sha2_256" \
    --vti-addr "$vti_1_ip_mask" \
    --vti-mtu 1400

# Tunnel-2
vti_2_ip_mask="$(cat /tmp/armfw-data.txt | grep "IPSEC_BGP_2_IP" | cut -f2 -d ':')"
oci_2_ip_mask="$(cat /tmp/armfw-data.txt | grep "IPSEC_BGP_2_IP" | cut -f3 -d ':')"
tunnel_2_pub_ip="$(cat /tmp/armfw-data.txt | grep "TUNNEL_2" | cut -f2 -d ':')"
tunnel_2_psk="$(cat /tmp/armfw-data.txt | grep "TUNNEL_2" | cut -f3 -d ':')"

./libreswan.sh add \
    --conn-name "oci-2" \
    --left "$my_prv_ip" \
    --left-id "$my_prv_ip" \
    --right "$tunnel_2_pub_ip" \
    --shared-secret "$tunnel_2_psk" \
    --ikev2 insist \
    --ike "aes_cbc256-sha2_384;modp1536" \
    --phase2alg "aes256-sha2_256" \
    --vti-addr "$vti_2_ip_mask" \
    --vti-mtu 1400

#-----#
# BGP #
#-----#

# Aguarda as interfaces ficarem UP
while true; do
    for iface in vti1 vti2; do
        if ip link show "$iface" 2>/dev/null | grep "UP"; then
            if [ "$iface" == "vti1" ]; then
                ./bird.sh bgp add \
                    --enabled yes \
                    --source-address "$vti_1_ip_mask" \
                    --local-as "$bgp_asn" \
                    --neighbor-ip "$oci_1_ip_mask" \
                    --neighbor-as 31898 \
                    --iface-name "vti1" \
                    --import-policy ipv4 \
                    --export-policy none
            else
                ./bird.sh bgp add \
                    --enabled yes \
                    --source-address "$vti_2_ip_mask" \
                    --local-as "$bgp_asn" \
                    --neighbor-ip "$oci_2_ip_mask" \
                    --neighbor-as 31898 \
                    --iface-name "vti2" \
                    --import-policy ipv4 \
                    --export-policy none
            fi
        fi
    done

    sleep 5
done

./services.sh start bird

rm -f /tmp/armfw-data.txt

exit 0