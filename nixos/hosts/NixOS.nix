{ config, suites, ... }:
{
  ### root password is empty by default ###
  imports = suites.NixOS;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    domain = config.networking.hostName;
    networkmanager.enable = true;
  };

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}
