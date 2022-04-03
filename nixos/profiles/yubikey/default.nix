{
  self,
  config,
  lib,
  options,
  profiles,
  pkgs,
  ...
}: let
  yubicoPackages = builtins.attrValues {
    inherit
      (pkgs)
      yubikey-manager
      ;
  };
in {
  imports = with profiles; [ssh misc.gnupg];

  age.ageBin = "PATH=$PATH:${lib.makeBinPath [pkgs.age-plugin-yubikey]} ${pkgs.rage}/bin/rage";

  age.identityPaths = options.age.identityPaths.default ++ ["${self}/secrets/ssh/age-yubikey-identity-a8555007.txt"];

  services.udev.packages = yubicoPackages;

  environment.systemPackages = yubicoPackages ++ [pkgs.age-plugin-yubikey];

  services.yubikey-agent.enable = true;

  programs.ssh.startAgent = false;

  # security.pam.yubico = {
  #   enable = true;
  #   debug = true;
  #   mode = "challenge-response";
  # };

  services.pcscd.enable = true;
}
