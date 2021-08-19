{ suites, config, ... }:
{
  ### root password is empty by default ###
  imports = suites.base;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    domain = config.networking.hostName;
    networkmanager.enable = true;
  };

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}
