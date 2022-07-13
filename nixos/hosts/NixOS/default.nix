{
  config,
  profiles,
  suites,
  ...
}: {
  ### root password is empty by default ###
  imports = lib.our.mkSuite (import ./suite.nix {inherit profiles suites;});

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    domain = config.networking.hostName;
    networkmanager.enable = true;
  };

  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
