{ pkgs, lib, ... }:
let
  mkDoH = { uri, addr }: {
    inherit uri addr;
    timeout = 4;
    sni = false;
  };
in
{
  imports = [ ../common ../disable-resolved ];

  networking.nameservers = lib.mkForce [ "127.0.0.1" ];

  # Setup our local DNS
  services.dcompass = {
    enable = true;
    package = pkgs.dcompass-maxmind;
    settings = {
      ratelimit = 50000;
      cache_size = 4096;
      upstreams = {
        secure.hybrid = [
          "moulticast-sg"
          "yepdns-sg"
          "ahadns"
          "blahdns-sg"
        ];

        ahadns.https = mkDoH {
          uri = "https://doh.au.ahadns.net/dns-query";
          addr = "103.73.64.132";
        };

        blahdns-sg.https = mkDoH {
          uri = "https://doh-sg.blahdns.com/dns-query";
          addr = "192.53.175.149";
        };

        moulticast-sg.https = mkDoH {
          uri = "https://dns.moulticast.net/dns-query";
          addr = "2001:678:d08:ff::53";
        };

        yepdns-sg.https = mkDoH {
          uri = "https://sg.yepdns.com/dns-query";
          addr = "2a04:3543:1000:2310:4831:c1ff:feb5:30a4";
        };
      };
      table = {
        start = [
          {
            query = {
              tag = "secure";
              cache_policy = "persistent";
            };
          }
          "end"
        ];
      };
      address = "[::]:53";
      verbosity = "info";
    };
  };
}