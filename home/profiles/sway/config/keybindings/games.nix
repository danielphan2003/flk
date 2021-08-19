{ pkgs, mod }:
let
  gamecheat = pkgs.callPackage ../scripts/gamecheat.nix { };
in
{
  "${mod}+g" = "exec ${gamecheat}";
}
