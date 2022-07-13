{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  path = "nwg-launchers/nwgbar";
  bar = import ./bar.nix {
    inherit self pkgs;
    inherit (config.home) username;
  };
in {
  xdg.configFile."${path}/bar.json".text = builtins.toJSON bar;
  xdg.configFile."${path}/style.css".source = ./style.css;
}
