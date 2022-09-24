{
  lib,
  pkgs,
  ...
}: {
  imports = lib.flk.getNixFiles ./.;

  home.packages = [
    pkgs.nwg-drawer
    pkgs.nwg-launchers
    pkgs.nwg-menu
    pkgs.nwg-panel
    pkgs.nwg-wrapper
  ];
}
