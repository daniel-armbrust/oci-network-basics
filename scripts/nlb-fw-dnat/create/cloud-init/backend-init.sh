#!/bin/bash

/usr/bin/dnf -y install traceroute net-tools tcpdump nginx

# Desabilita o SELinux
setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Desabilita o Firewall do Sistema Operacional
/usr/bin/systemctl disable --now firewalld

# Aumenta o tamanho do boot volume
/usr/libexec/oci-growfs -y

cat > /etc/nginx/nginx.conf <<'EOF'
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    access_log /var/log/nginx/access.log;

    server {
        listen 80;
        server_name _;

        location / {
            return 200 "NGINX Port 80 OK\n";
        }
    }

    server {
        listen 443;
        server_name _;

        location / {
            return 200 "NGINX Port 443 OK\n";
        }
    }

    server {
        listen 9001;
        server_name _;

        location / {
            return 200 "NGINX Port 9001 OK\n";
        }
    }
}
EOF

systemctl enable nginx
systemctl restart nginx

exit 0