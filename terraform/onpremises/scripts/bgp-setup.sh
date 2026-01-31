#!/bin/bash

private_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-ip`"

tunnel_1_bgp_local_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-local-ip`"
tunnel_1_bgp_oci_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-oci-ip`"
tunnel_1_bgp_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-1-bgp-cidr`"

tunnel_2_bgp_local_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-local-ip`"
tunnel_2_bgp_oci_ip="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-oci-ip`"
tunnel_2_bgp_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/tunnel-2-bgp-cidr`"

internet_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/internet-cidr`"
rede_app_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-app-cidr`"
rede_backup_cidr="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/rede-backup-cidr`"

onpremises_asn="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/onpremises-asn`"
oracle_asn="`curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/metadata/oracle-asn`"

cat <<EOF >/usr/local/etc/bird.conf
router id ${private_ip};
log syslog all;

protocol device {
   scan time 3;
}

protocol kernel {
  ipv4 {
      import all;
      export all;     
  };
  persist;
}

protocol static {
    ipv4;
    route ${internet_cidr} via "vti1";
    route ${internet_cidr} via "vti2";
    route ${rede_app_cidr} via "vti1";
    route ${rede_app_cidr} via "vti2";
    route ${rede_backup_cidr} via "vti1";
    route ${rede_backup_cidr} via "vti2";
}

filter prepend_aspath {
    bgp_path.prepend(64515);
    accept;
}

protocol bgp oci_tunnel_1 {
  local ${tunnel_1_bgp_local_ip} as ${onpremises_asn};
  interface "vti1";

  neighbor ${tunnel_1_bgp_oci_ip} as ${oracle_asn};  

  graceful restart;
  capabilities off;

  ipv4 {
        import all;
        export all;
  };
}

protocol bgp oci_tunnel_2 {
  local ${tunnel_2_bgp_local_ip} as ${onpremises_asn};
  interface "vti2";
  
  neighbor ${tunnel_2_bgp_oci_ip} as ${oracle_asn};
  
  graceful restart;
  capabilities off;

  ipv4 {
        import all;
        export all;

        # Deixa o Tunel #2 com prioridade menor.
        export filter prepend_aspath;
  };
}
EOF

# Daemon BIRD.
/usr/local/sbin/bird -c /usr/local/etc/bird.conf

exit 0