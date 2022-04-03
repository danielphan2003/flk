{
  hmUsers,
  lib,
  ...
}: let
  user = "nixos";
in {
  home-manager.users."${user}" = hmUsers."${user}";

  users.users."${user}" = {
    uid = 1000;
    password = lib.mkDefault "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
