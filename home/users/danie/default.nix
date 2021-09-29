{ self, hmUsers, pkgs, lib, config, ... }:
let user = "danie"; in
{
  home-manager.users."${user}" = hmUsers."${user}";

  services.greetd.settings = {
    initial_session = {
      inherit user;
      command = ''/run/current-system/sw/bin/sway --config ${config.users.users."${user}".home}/.config/sway/config'';
    };
  };

  age.secrets = {
    accounts = {
      file = "${self}/secrets/home/profiles/accounts.age";
      owner = user;
      group = "users";
    };
    "${user}".file = "${self}/secrets/home/users/${user}.age";
    "wayvnc/config" = {
      file = "${self}/secrets/home/profiles/wayvnc/config.age";
      owner = user;
      group = "users";
    };
    "wayvnc/key.pem" = {
      file = "${self}/secrets/home/profiles/wayvnc/key.pem.age";
      owner = user;
      group = "users";
    };
    "wayvnc/cert.pem" = {
      file = "${self}/secrets/home/profiles/wayvnc/cert.pem.age";
      owner = user;
      group = "users";
    };
  };

  environment.systemPackages = [ pkgs."${user}-logo" ];

  users.users."${user}" = {
    description = "Daniel Phan";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" "adbusers" "input" "podman" ];
    passwordFile = config.age.secrets."${user}".path;
    openssh.authorizedKeys.keyFiles = [ "${self}/secrets/ssh/${user}.pub" ];
  };
}
