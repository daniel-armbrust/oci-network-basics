#!/bin/bash

/usr/bin/dnf -y install traceroute net-tools tcpdump

# Desabilita o SELinux
setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Desabilita o Firewall do Sistema Operacional
/usr/bin/systemctl disable --now firewalld

# Aumenta o tamanho do boot volume
/usr/libexec/oci-growfs -y

# Cria o arquivo rc-firewall.sh
cat <<'EOF' >/etc/rc-firewall.sh
#!/bin/bash

iface="$(ip route | grep default | awk '{print $5}')"

iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables -t nat -A POSTROUTING -o "$iface" -j MASQUERADE

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

exit 0
EOF

# Cria o arquivo rc.local
cat <<EOF >/etc/rc.d/rc.local
#!/bin/bash

/etc/rc-firewall.sh

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

# Inicia e habilita o serviço rc-local
chmod +x /etc/rc.d/rc.local
chmod +x /etc/rc-firewall.sh

systemctl daemon-reexec
systemctl enable --now rc-local

exit 0