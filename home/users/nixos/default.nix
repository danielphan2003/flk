{ hmUsers, ... }:
let user = "nixos"; in
{
  home-manager.users."${user}" = hmUsers."${user}";

  users.users."${user}" = {
    uid = 1000;
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
