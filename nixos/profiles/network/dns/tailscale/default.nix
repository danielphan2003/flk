{ pkgs
, lib
, config
, profiles
, hostConfigs
, self
, ...
}:
let
  inherit (lib) concatStringsSep hasSuffix mkAfter mkBefore mkForce partition;
  inherit (builtins) attrNames attrValues;

  inherit (config.networking) hostName;
  inherit (config.services.tailscale) interfaceName port package;

  inherit (hostConfigs.tailscale) nameserver tailnet_alias;
  inherit (hostConfigs.hosts."${hostName}") tailnet_domain type;

  tailscale-age-id =
    if type == "permanant"
    then "tailscale-${hostName}"
    else "tailscale-${type}";

  tailscale-age-key = "${self}/secrets/nixos/profiles/network/tailscale/${hostName}.age";

  caddy-tls-folder =
    "/var/lib/caddy/.local/share/caddy/certificates/tailscale/${tailnet_domain}";

  caddy-tls-file = type:
    "${caddy-tls-folder}/${tailnet_domain}.${type}";

  caddy-tls-cert = caddy-tls-file "crt";

  caddy-tls-key = caddy-tls-file "key";
in
{
  imports = with profiles.network.dns; [ disable-resolved ];

  age.secrets = {
    "${tailscale-age-id}".file = tailscale-age-key;
    tailscale-custom-doh.file = "${self}/secrets/nixos/profiles/network/tailscale/custom-doh.age";
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ port ];
      trustedInterfaces = [ interfaceName ];
    };
    search = [ nameserver tailnet_alias ];
    nameservers = [ "100.100.100.100" ];
  };

  services.tailscale = {
    enable = true;
    port = 41641;
    interfaceName = "tailscale0";
    # note: should machines uses dot and only use MagicDNS for ts traffics?
    package = pkgs.tailscale.override {
      # hacky, but good enough
      inherit hostName;
      customDoHPath = config.age.secrets.tailscale-custom-doh.path;
    };
  };

  services.resolved.dnssec = "false";

  services.caddy.virtualHosts."${tailnet_domain}" = {
    extraConfig = lib.mkBefore ''
      import common
      import logging ${tailnet_domain}

      tls ${caddy-tls-cert} ${caddy-tls-key}
    '';
  };

  systemd.services.tailnet-cert-renew = {
    enable = config.services.caddy.enable;

    description = "Renew TLS cert from Tailscale";

    # make sure tailscaled is running before trying to connect to tailscale
    before = [ "network-online.target" "caddy.service" ];
    after = [ "network-pre.target" "tailscaled.service" ];
    wants = [ "network-pre.target" "tailscaled.service" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    path = [ package ];

    script = ''
      mkdir -p ${caddy-tls-folder}

      tailscale cert \
        --cert-file "${caddy-tls-cert}" \
        --key-file "${caddy-tls-key}" \
        "${tailnet_domain}"
    '';
  };

  systemd.timers.tailnet-cert-renew = {
    enable = config.services.caddy.enable;

    description = "Renew Tailscale TLS cert weekly";

    wantedBy = [ "basic.target" ];

    timerConfig = {
      OnCalendar = "weekly";
      OnBootSec = 300;
      Persistent = true;
      Unit = "tailnet-cert-renew.service";
    };
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscaled is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscaled.service" ];
    wants = [ "network-pre.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # restart service if tailscale key change (after a 90-day period)
    restartTriggers = [ tailscale-age-key ];

    path = attrValues {
      inherit (pkgs) jq;
      inherit package;
    };

    # have the job run this shell script
    script = ''tailscale up --authkey="file:${config.age.secrets."${tailscale-age-id}".path}"'';
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
