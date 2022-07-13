{profiles}: {
  networking = {inherit (profiles.networking) networkd qos;};

  networking.vpns = {inherit (profiles.networking.vpns) tailscale;};
}
