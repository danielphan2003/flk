{
  self,
  lib,
  profiles,
  pkgs,
  ...
}: {
  imports = [profiles.services.openssh];

  age.ageBin = "PATH=$PATH:${lib.makeBinPath [pkgs.age-plugin-yubikey]} ${pkgs.rage}/bin/rage";

  age.identityPaths = lib.mkOptionDefault ["${self}/secrets/ssh/age-yubikey-identity-a8555007.txt"];

  services.udev.packages = [pkgs.yubikey-personalization];

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      age-plugin-yubikey
      yubikey-personalization
      yubikey-personalization-gui
      yubikey-manager
      ;
  };

  services.yubikey-agent.enable = true;

  # services.piv-agent.enable = true;

  # programs.ssh.startAgent = false;

  # security.pam.yubico = {
  #   enable = true;
  #   debug = true;
  #   mode = "challenge-response";
  # };

  services.pcscd.enable = true;
}
