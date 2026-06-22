#!/bin/bash

/usr/bin/dnf -y install traceroute net-tools tcpdump python36-oci-cli.noarch

# Desabilita o SELinux
setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Desabilita o Firewall do Sistema Operacional
/usr/bin/systemctl disable --now firewalld

# Aumenta o tamanho do boot volume
/usr/libexec/oci-growfs -y

cat > /etc/rc.d/rc.local <<'EOF'
#!/bin/bash

#-------------------#
# IPs Data Download #
#-------------------#
oci os object get --bucket-name firewall-data --name firewall-data.txt \
    --file /tmp/firewall-data.txt --auth instance_principal

# Enable IP Forward
echo 1 > /proc/sys/net/ipv4/ip_forward

# DNAT - NLB-1 to Backend Server #1
nlb_1_pub_ip="$(grep 'NLB_1_PUB_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"
nlb_1_prv_ip="$(grep 'NLB_1_PRV_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"
bcksrv_1_ip="$(grep 'BACKSRV_1_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_1_prv_ip" --dport 80 \
     -j DNAT --to-destination "$bcksrv_1_ip:80"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_1_prv_ip" --dport 443 \
     -j DNAT --to-destination "$bcksrv_1_ip:443"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_1_prv_ip" --dport 9001 \
     -j DNAT --to-destination "$bcksrv_1_ip:9001"

# DNAT - NLB-2 to Backend Server #2
nlb_2_pub_ip="$(grep 'NLB_2_PUB_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"
nlb_2_prv_ip="$(grep 'NLB_2_PRV_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"
bcksrv_2_ip="$(grep 'BACKSRV_2_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_2_prv_ip" --dport 80 \
     -j DNAT --to-destination "$bcksrv_2_ip:80"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_2_prv_ip" --dport 443 \
     -j DNAT --to-destination "$bcksrv_2_ip:443"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_2_prv_ip" --dport 9001 \
     -j DNAT --to-destination "$bcksrv_2_ip:9001"

# DNAT - NLB-3 to Backend Server #3
nlb_3_pub_ip="$(grep 'NLB_3_PUB_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"
nlb_3_prv_ip="$(grep 'NLB_3_PRV_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"
bcksrv_3_ip="$(grep 'BACKSRV_3_IP' /tmp/firewall-data.txt | cut -f2 -d ':')"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_3_prv_ip" --dport 80 \
     -j DNAT --to-destination "$bcksrv_3_ip:80"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_3_prv_ip" --dport 443 \
     -j DNAT --to-destination "$bcksrv_3_ip:443"

iptables -t nat -A PREROUTING -p tcp -d "$nlb_3_prv_ip" --dport 9001 \
     -j DNAT --to-destination "$bcksrv_3_ip:9001"

rm -f /tmp/firewall-data.txt

exit 0
EOF

cat <<EOF > /etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local
TimeoutSec=0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable and Start rc-local
chmod +x /etc/rc.d/rc.local
ln -sf /etc/rc.d/rc.local /etc/rc.local

systemctl daemon-reexec
systemctl enable --now rc-local

exit 0