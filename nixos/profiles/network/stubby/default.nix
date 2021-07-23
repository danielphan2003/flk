{ lib, ... }:
let inherit (lib) mkForce mkBefore;
in
{
  networking.firewall.allowedTCPPorts = [ 53 5300 ];

  services.stubby = {
    enable = true;
    listenAddresses = [ "0::1@53000" "127.0.0.1@53000" ];
    upstreamServers = ''
      ## Quad9
      - address_data: 2620:fe::fe
        tls_auth_name: "dns.quad9.net"
      - address_data: 2620:fe::9
        tls_auth_name: "dns.quad9.net"
      - address_data: 9.9.9.9
        tls_auth_name: "dns.quad9.net"
      - address_data: 149.112.112.112
        tls_auth_name: "dns.quad9.net"
    '';
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        do-not-query-localhost = false;
        do-ip4 = true;
        do-ip6 = true;
        do-tcp = true;
        do-udp = true;
        udp-upstream-without-downstream = true;
        qname-minimisation = true;
        incoming-num-tcp = 1000;
        interface = [ "0.0.0.0@53" "::0@53" ];
      };
      forward-zone = [{
        name = ".";
        forward-addr = [ "::1@53000" "127.0.0.1@53000" ];
      }];
    };
  };

  # networking.networkmanager.insertNameservers = mkForce [
  #   "::1" "127.0.0.1"
  # ];

  networking = {
    resolvconf.dnsExtensionMechanism = false;
    networkmanager.dns = "none";
    nameservers = mkBefore [
      "::1"
      "127.0.0.1"
    ];
  };
}
