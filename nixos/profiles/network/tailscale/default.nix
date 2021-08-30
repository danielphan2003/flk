{ pkgs, config, self, ... }:
let
  inherit (config.networking) hostName;
  tailscale-age-key = "${self}/secrets/nixos/profiles/network/tailscale/${hostName}.age";
in
{
  age.secrets."tailscale-${hostName}".file = tailscale-age-key;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # restart service if tailscale key change (after a 90-day period)
    restartTriggers = [ tailscale-age-key ];

    # have the job run this shell script
    script = with pkgs; ''
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      [[ $status = "Running" ]] && exit 0

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up --authkey="$(< /run/secrets/tailscale-${hostName})"
    '';
  };
}
