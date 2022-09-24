# unmaintained
{pkgs, ...}: {
  home.packages = let
    edgeCompat =
      if pkgs.system != "x86_64-linux"
      then {inherit (pkgs) microsoft-edge-beta;}
      else {};

    edgePkgs = {};
  in
    builtins.attrValues (edgeCompat // edgePkgs);
}
