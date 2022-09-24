{
  inputs,
  cell,
}: let
  inherit (inputs) Cells;
  nixosProfiles = Cells.nixos.profiles;
in {
  boot = {inherit (nixosProfiles.boot) secure;};

  file-systems = {inherit (nixosProfiles.file-systems) btrfs;};

  gui = {inherit (nixosProfiles.gui) ibus;};

  gui.platforms = {inherit (nixosProfiles.gui.platforms) xwayland;};

  gui.themes = {inherit (nixosProfiles.gui.themes) sefia;};

  hardware = {inherit (nixosProfiles.hardware) firmware;};

  i18n = {inherit (nixosProfiles.i18n) vi-vn;};

  networking = {
    inherit
      (nixosProfiles.networking)
      playit
      # zerotier
      ;
  };

  programs = {
    inherit
      (nixosProfiles.programs)
      audio
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
      ;
  };

  programs.chill = {
    inherit
      (nixosProfiles.programs.chill)
      reading
      watching
      weebs
      ;
  };

  security = {inherit (nixosProfiles.security) disable-mitigations doas;};

  services = {
    inherit
      (nixosProfiles.services)
      aria2
      # calibre-web
      
      netdata
      peerix
      physlock
      # swhkd
      
      wayvnc
      ;
  };

  # virtualisation = {inherit (nixosProfiles.virtualisation) windows;};
}
