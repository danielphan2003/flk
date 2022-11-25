let
  inherit (inputs.cells) nixos;
  inherit (nixos) nixosProfiles;
in {
  themachine = {
    imports =
      [
        nixosProfiles.boot.plymouth
        nixosProfiles.boot.secure
        nixosProfiles.gui.ibus
        nixosProfiles.gui.platforms.xwayland
        nixosProfiles.gui.themes.sefia
        nixosProfiles.hardware.firmware
        nixosProfiles.i18n.vi-vn
        nixosProfiles.networking.playit
        # nixosProfiles.networking.zerotier
        nixosProfiles.security.disable-mitigations
        nixosProfiles.security.doas
        # nixosProfiles.virtualisation.windows
        cell.nixosSuites.compounds
        cell.nixosSuites.consumables
      ]
      ++ nixos.nixosSuites.ephemeral-crypt
      ++ nixos.nixosSuites.insular
      ++ nixos.nixosSuites.networking
      ++ nixos.nixosSuites.open-based
      ++ nixos.nixosSuites.modern
      ++ nixos.nixosSuites.personal
      ++ nixos.nixosSuites.play
      ++ nixos.nixosSuites.producer;
    networking.hostName = "themachine";
  };

  compounds = {
    imports = with nixosProfiles.programs; [
      audio
      chill.reading
      chill.watching
      chill.weebs
      compression
      develop
      file-systems
      gnupg
      graphical
      media
      meeting
      misc
      remote
      vpn
      yubikey
    ];
  };

  consumables = {
    imports = with nixosProfiles.services; [
      aria2
      # calibre-web

      netdata
      # peerix
      # physlock
      # swhkd

      # wayvnc
    ];
  };
}
