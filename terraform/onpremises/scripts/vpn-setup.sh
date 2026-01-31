#!/bin/bash

# https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/libreswan.htm

private_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-ip`"
internet_iface="`ip -o -f inet addr show | grep "$private_ip" | awk '{print $2}'`"

ipsec_pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/pub-ip`"

tunnel_1_bgp_local_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-local-ip`"
tunnel_1_bgp_local_ip_mask="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-local-ip-mask`"
tunnel_1_bgp_oci_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-oci-ip`"
tunnel_1_bgp_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-cidr`"
tunnel_1_oci_pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-oci-pubip`"
tunnel_1_shared_secret="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-shared-secret`"

tunnel_2_bgp_local_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-local-ip`"
tunnel_2_bgp_local_ip_mask="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-local-ip-mask`"
tunnel_2_bgp_oci_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-oci-ip`"
tunnel_2_bgp_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-cidr`"
tunnel_2_oci_pub_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-oci-pubip`"
tunnel_2_shared_secret="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-shared-secret`"

# Configurações IPSec.
cat <<EOF >/etc/ipsec.d/oci-ipsec.conf
conn oracle-tunnel-1
     left=${private_ip}
     leftid=${private_ip}
     right=${tunnel_1_oci_pub_ip}     
     authby=secret
     leftsubnet=0.0.0.0/0 
     rightsubnet=0.0.0.0/0
     auto=start
     mark=5/0xffffffff
     vti-interface=vti1
     vti-routing=no    
     phase2alg=aes_gcm256;modp1536
     encapsulation=yes
     ikelifetime=28800s
     salifetime=3600s
     ikev2=insist
     ike=aes256-sha2_384;modp1536
     rekeymargin=3m
     rekey=yes
conn oracle-tunnel-2
     left=${private_ip}
     leftid=${private_ip}
     right=${tunnel_2_oci_pub_ip}
     authby=secret
     leftsubnet=0.0.0.0/0
     rightsubnet=0.0.0.0/0
     auto=start
     mark=6/0xffffffff
     vti-interface=vti2
     vti-routing=no
     phase2alg=aes_gcm256;modp1536
     encapsulation=yes
     ikelifetime=28800s
     salifetime=3600s
     ikev2=insist
     ike=aes256-sha2_384;modp1536
     rekeymargin=3m
     rekey=yes     
EOF

# Secrets IPSec.
cat <<EOF >/etc/ipsec.d/oci-ipsec.secrets
${private_ip} ${tunnel_1_oci_pub_ip}: PSK "${tunnel_1_shared_secret}"
${private_ip} ${tunnel_2_oci_pub_ip}: PSK "${tunnel_2_shared_secret}"
EOF

chmod 0400 /etc/ipsec.d/oci-ipsec.secrets

cat <<'EOF' >/etc/vti_setup.sh
#!/bin/bash

tunnel_1_bgp_local_ip_mask="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-local-ip-mask`"
tunnel_1_bgp_oci_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-oci-ip`"

tunnel_2_bgp_local_ip_mask="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-local-ip-mask`"
tunnel_2_bgp_oci_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-oci-ip`"

# Aguarda a criação das interfaces VTI.
while [ true ]; do
   vti1_iface="`ifconfig | grep '^vti1: '`"
   vti2_iface="`ifconfig | grep '^vti1: '`"

   if [ ! -z "$vti1_iface" ]; then
      if [ ! -z "$vti2_iface" ]; then
         break
      fi
   fi

   sleep 1s
done

ip addr add ${tunnel_1_bgp_local_ip_mask} dev vti1
ip link set dev vti1 up mtu 1480
ip route add ${tunnel_1_bgp_oci_ip}/32 nexthop dev vti1

echo 0 > /proc/sys/net/ipv4/conf/vti1/rp_filter

ip addr add ${tunnel_2_bgp_local_ip_mask} dev vti2
ip link set dev vti2 up mtu 1480
ip route add ${tunnel_2_bgp_oci_ip}/32 nexthop dev vti2

echo 0 > /proc/sys/net/ipv4/conf/vti2/rp_filter

exit 0
EOF

chmod +x /etc/vti_setup.sh
sed -i 's|^#\?\s*ExecStartPost=/usr/libexec/ipsec/portexcludes|ExecStartPost=/etc/vti_setup.sh|' /usr/lib/systemd/system/ipsec.service
systemctl daemon-reload

# Habiltia e inicia o serviço de VPN.
systemctl enable ipsec
systemctl start ipsec

exit 0