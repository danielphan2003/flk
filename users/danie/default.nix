{ pkgs, self, ... }:
let gpgKey = "A3556DCE587353FB";
in
{
  home-manager.users.danie = { suites, ... }: {
    imports = suites.danie;
    programs.gpg.settings.default-key = gpgKey;
    services.gpg-agent.sshKeys = [
      "251E48ED4B7C2CC2C02828EBF7BE3592FC4ECA17"
    ];
    programs.git = {
      userEmail = "danielphan.2003@gmail.com";
      userName = "Daniel Phan";

      signing = {
        key = gpgKey;
        signByDefault = true;
      };
    };
  };

  age.secrets = {
    accounts = {
      file = "${self}/secrets/accounts.age";
      owner = "danie";
      group = "users";
    };
    danie.file = "${self}/secrets/danie.age";
  };

  environment.systemPackages = with pkgs; [ danie-logo ];

  users.users.danie = {
    uid = 1000;
    description = "Daniel Phan";
    isNormalUser = true;
    isSystemUser = false;
    extraGroups = [ "wheel" "libvirtd" "kvm" "adbusers" "input" "podman" ];
    passwordFile = "/run/secrets/danie";
  };
}
