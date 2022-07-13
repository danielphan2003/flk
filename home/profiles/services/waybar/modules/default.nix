args @ {
  pkgs,
  lib,
  ...
}: let
  left = import ./left args;
  center = import ./center args;
  right = import ./right args;

  modules-list = left // center // right;

  modules =
    builtins.removeAttrs
    modules-list
    ["modules-left" "modules-center" "modules-right"];
in {
  inherit (modules-list) modules-left modules-center modules-right;
  inherit modules;
  position = "bottom";
}
