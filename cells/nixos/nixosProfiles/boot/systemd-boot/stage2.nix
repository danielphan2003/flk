{lib, ...}: let
  inherit (lib) mkAfter mkDefault mkForce;
in {
  boot.loader.timeout = mkDefault 1;

  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  boot.loader.systemd-boot = {
    # enable = mkAfter true;
    memtest86.enable = mkDefault true;
    configurationLimit = mkDefault 5;
    # consoleMode = mkForce "max";
  };
}
