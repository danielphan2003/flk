{
  inputs,
  cell
}: let
  inherit (inputs) Cells;
  nixosProfiles = Cells.nixos.profiles;
in {
  # desktop = {inherit (desktop) pipewire;};

  file-systems = {inherit (nixosProfiles.file-systems) btrfs;};

  hardware = {inherit (nixosProfiles.hardware) argonone firmware;};

  i18n = {inherit (nixosProfiles.i18n) vi-vn;};

  programs = {
    inherit
      (nixosProfiles.programs)
      compression
      file-systems
      rpi
      ;
  };

  security = {inherit (nixosProfiles.security) doas;};

  services = {
    inherit
      (nixosProfiles.services)
      adguardhome
      caddy
      # calibre-server
      
      cinny # TODO: tailscale
      etebase-server # TODO: tailscale
      # grafana TODO: tailscale
      
      # jitsi
      
      logrotate
      # minecraft
      
      # matrix
      
      matrix-conduit
      # matrix-identity
      
      peerix
      postgresql
      rss-bridge
      # spotifyd
      
      vaultwarden
      wkd
      ;
  };
}
