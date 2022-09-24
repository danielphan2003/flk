{config, ...}: {
  imports = builtins.attrValues {
    inherit
      (inputs.nixos-hardware.nixosModules)
      common-pc-ssd
      raspberry-pi-4
      ;
  };

  hardware.raspberry-pi."4" = {
    # Enable GPU acceleration
    fkms-3d.enable = true;
    audio.enable = config.services.spotifyd.enable;
  };

  nix.settings.max-jobs = 4;
}
