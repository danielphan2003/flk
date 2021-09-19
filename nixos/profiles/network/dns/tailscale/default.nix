{ pkgs, lib, config, self, latestModulesPath, ... }:
let
  inherit (lib.our) hostConfigs;
  inherit (config.networking) hostName;
  inherit (config.services.tailscale) interfaceName port package;

  tailscale-age-key = "${self}/secrets/nixos/profiles/network/tailscale/${hostName}.age";
in
{
  imports = [ ../common ] ++
    [ "${latestModulesPath}/services/networking/tailscale.nix" ];

  disabledModules = [ "services/networking/tailscale.nix" ];

  age.secrets."tailscale-${hostName}".file = tailscale-age-key;

  networking = {
    firewall = {
      allowedUDPPorts = [ port ];
      trustedInterfaces = [ interfaceName ];
    };
    search = [ hostConfigs.tailscale.nameserver ];
    nameservers = [ "100.100.100.100" ];
  };

  services.tailscale = {
    enable = true;
    port = 41641;
    interfaceName = "tailscale0";
  };

  systemd.services.tailscaled = {
    wants = [ "network-pre.target" "systemd-networkd.service" ];
    after = [ "network-pre.target" "systemd-networkd.service" ];
  };

  systemd.services.systemd-resolved = {
    wants = [ "tailscaled.service" "nss-lookup.target" ];
    after = [ "systemd-sysusers.service" "tailscaled.service" "systemd-networkd.service" ];
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

    path = builtins.attrValues {
      inherit (pkgs) jq;
      inherit package;
    };

    # have the job run this shell script
    script = ''
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(tailscale status -json | jq -r .BackendState)"
      [[ $status = "Running" ]] && exit 0

      # otherwise authenticate with tailscale
      tailscale up --authkey="$(< /run/secrets/tailscale-${hostName})"
    '';
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
