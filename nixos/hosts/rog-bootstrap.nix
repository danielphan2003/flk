# NixOS liveCD configuration to generate an iso to interact with rog laptops
# To build the iso:
# nixos-generate -f iso --system x86_64-linux --flake .\#rog-bootstrap
{
  config,
  profiles,
  suites,
  nixosModulesPath,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports =
    [
      profiles.apps.fonts.fancy
      profiles.laptop
    ]
    ++ suites.bootstrap;

  users.users.nixos.password = lib.mkForce "";

  boot.kernelPackages = pkgs.linuxPackages_5_17;

  boot.loader.grub.enable = lib.mkDefault true;

  networking.domain = config.networking.hostName;

  networking.networkmanager.enable = !config.networking.wireless.iwd.enable;

  services.asusd.enable = true;

  programs.sway.enable = true;

  environment.etc."sway/config".text = ''
    include ${pkgs.sway}/etc/sway/config
    bindsym Mod1+Return ${pkgs.wezterm}/bin/wezterm
    exec systemctl --user import-environment
  '';

  systemd.services.battery-charge-threshold.enable = false;

  services.xserver.videoDrivers = [];

  hardware.nvidia.prime.offload.enable = false;

  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
