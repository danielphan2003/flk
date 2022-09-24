{
  self,
  cells,
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.danie.imports = cells.flk.users.danie.home.modules.default;

  users.users.danie = {
    description = "Daniel Phan";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "adbusers" "input" "podman"];
  };
}