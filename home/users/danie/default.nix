{
  self,
  config,
  hmUsers,
  lib,
  pkgs,
  ...
}: let
  user = "danie";
in {
  home-manager.users."${user}" = hmUsers."${user}";

  services.greetd.settings = {
    initial_session = {
      inherit user;
      command = ''/run/current-system/sw/bin/sway --config ${config.users.users."${user}".home}/.config/sway/config'';
    };
  };

  age.secrets = let
    mkUserSecret = file: attrs:
      {
        inherit file;
        owner = user;
        group = "users";
      }
      // attrs;
    mkProfileSecret = file: attrs: {
      "${file}" =
        mkUserSecret "${self}/secrets/home/profiles/${file}.age"
        {
          path = "${config.users.users."${user}".home}/.config/${file}";
          symlink = false;
        }
        // attrs;
    };
  in
    {"${user}".file = "${self}/secrets/home/users/${user}.age";}
    // (mkProfileSecret "accounts" {});

  users.users."${user}" = {
    description = "Daniel Phan";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "adbusers" "input" "podman"];
    passwordFile = config.age.secrets."${user}".path;
    openssh.authorizedKeys.keyFiles = ["${self}/secrets/ssh/${user}.pub"];
  };
}
