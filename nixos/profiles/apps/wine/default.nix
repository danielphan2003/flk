{pkgs, ...}: let
  inherit (builtins) attrValues;
in {
  environment.systemPackages =
    if pkgs.system == "x86_64-linux"
    then
      attrValues
      {
        inherit (pkgs) bottles lutris winetricks;
        inherit (pkgs.wineWowPackages) staging;
      }
    else [];
}
