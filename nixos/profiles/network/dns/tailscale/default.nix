{ pkgs, lib, config, self, latestModulesPath, ... }:
let
  inherit (config.networking) hostName;
  inherit (config.services.tailscale)
    interfaceName port package;
  inherit (lib.our.hostConfigs.tailscale) nameserver;

  tailscale-age-id = "tailscale-${hostName}";
  tailscale-age-key = "${self}/secrets/nixos/profiles/network/tailscale/${hostName}.age";
in
{
  imports = [ "${latestModulesPath}/services/networking/tailscale.nix" ];

  disabledModules = [ "services/networking/tailscale.nix" ];

  age.secrets."${tailscale-age-id}".file = tailscale-age-key;

  networking = {
    firewall = {
      allowedUDPPorts = [ port ];
      trustedInterfaces = [ interfaceName ];
    };
    search = [ nameserver ];
    nameservers = lib.mkBefore [ "100.100.100.100" ];
  };

  services.tailscale = {
    enable = true;
    port = 41641;
    interfaceName = "tailscale0";
  };

  services.resolved.dnssec = "false";

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

    path = builtins.attrValues {
      inherit (pkgs) jq;
      inherit package;
    };

    # have the job run this shell script
    script = ''
      # otherwise authenticate with tailscale
      tailscale up --authkey="$(< ${config.age.secrets."${tailscale-age-id}".path})"
    '';
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
