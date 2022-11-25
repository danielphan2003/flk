let
  inherit (inputs.cells) nixos;
  inherit (nixos) nixosProfiles;
in {
  pik2 = {
    imports =
      [
        nixosProfiles.i18n.vi-vn
        nixosProfiles.programs.compression
        nixosProfiles.programs.file-systems
        nixosProfiles.programs.rpi
        nixosProfiles.security.doas
        cell.hardwareProfiles.pik2
        cell.nixosSuites.consumables
      ]
      ++ nixos.nixosSuites.ephemeral-crypt
      ++ nixos.nixosSuites.open-based
      ++ nixos.nixosSuites.server;
  };

  consumables = {
    imports = with nixos.nixosProfiles.services; [
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

      # peerix
      postgresql
      rss-bridge
      # spotifyd

      vaultwarden
      wkd
    ];
  };
}
