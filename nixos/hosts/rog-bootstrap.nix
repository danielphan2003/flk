{
  config,
  profiles,
  suites,
  nixosModulesPath,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      profiles.apps.fonts.fancy
    ]
    ++ suites.bootstrap;

  users.users.nixos.initialHashedPassword = "";

  boot.kernelPackages = pkgs.linuxPackages_5_17;

  boot.loader.grub.enable = lib.mkDefault true;

  networking.domain = config.networking.hostName;

  networking.wireless.enable = true;

  networking.networkmanager.enable = !config.networking.wireless.enable;

  services.asusd.enable = true;

  programs.sway.enable = true;

  environment.etc."sway/config".text = ''
    include ${pkgs.sway}/etc/sway/config
    bindsym Mod1+Return ${pkgs.wezterm}/bin/wezterm
    exec systemctl --user import-environment
  '';
}
