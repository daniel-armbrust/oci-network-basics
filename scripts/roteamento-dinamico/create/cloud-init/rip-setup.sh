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

#-------------------#
# Libreswan Service #
#-------------------#
./services.sh install libreswan
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

./firewall.sh filter add --chain INPUT --src-addr 10.255.0.0/16 --protocol-name all \
    --action ACCEPT

./firewall.sh filter add --chain FORWARD --src-addr 10.255.0.0/16 \
    --protocol-name all --action ACCEPT

./firewall.sh filter add --chain FORWARD --dst-addr 10.255.0.0/16 \
    --protocol-name all --action ACCEPT

#-------------#
# IPSec Setup #
#-------------#
my_hostname="$(hostname)"
my_prv_ip="$(hostname -I)"
my_pub_ip="$(grep "$my_hostname" /tmp/armfw-data.txt | cut -f2 -d ':')"
my_shared_secret="$(grep "$my_hostname" /tmp/armfw-data.txt | cut -f3 -d ':')"
my_vti_1_ip_mask="$(grep "$my_hostname" /tmp/armfw-data.txt | cut -f4 -d ':')"
my_vti_2_ip_mask="$(grep "$my_hostname" /tmp/armfw-data.txt | cut -f5 -d ':')"

count=0
grep -v "$(hostname)" /tmp/armfw-data.txt | while IFS= read -r line; do
    hostname="$(echo -n "$line" | cut -f1 -d ':')"
    pub_ip="$(echo -n "$line" | cut -f2 -d ':')"
    shared_secret="$(echo -n "$line" | cut -f2 -d ':')"

    count=$((count + 1))

    if [ "$count" -eq 1 ]; then
        ./libreswan.sh add \
            --conn-name "$hostname-$count" \
            --left "$my_prv_ip" \
            --left-id "$my_pub_ip" \
            --right "$pub_ip" \
            --shared-secret "$my_shared_secret" \
            --ikev2 insist \
            --vti-addr "$my_vti_1_ip_mask" \
            --vti-mtu 1400
        
    elif [ "$count" -eq 2 ]; then
        ./libreswan.sh add \
            --conn-name "$hostname-$count" \
            --left "$my_prv_ip" \
            --left-id "$my_pub_ip" \
            --right "$pub_ip" \
            --shared-secret "$my_shared_secret" \
            --ikev2 insist \
            --vti-addr "$my_vti_2_ip_mask" \
            --vti-mtu 1400
    fi
done

rm -f /tmp/armfw-data.txt

#----------------#
# BIRD RIP Setup #
#----------------#
dnf -y install bird

cat >/usr/local/etc/bird.conf <<EOF
log "/var/log/bird.log" { info, remote, warning, error, auth, fatal, bug };

protocol device {
}

protocol direct {
    ipv4;
    interface "*";
}

protocol kernel {
    ipv4 {
        import all;
        export all;
    };

    kernel table 254;
}

protocol rip {
    ipv4 {
        import all;
        export all;
    };

    interface "*";
}
EOF

bird -c /usr/local/etc/bird.conf

exit 0