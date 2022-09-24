{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  boot.plymouth = {
    enable = mkDefault true;

    # to be overriden by profiles.gui.themes.sefia
    theme = mkDefault "hexagon_dots_alt"; # or "connect";

    themePackages = mkDefault [(pkgs.plymouth-themes.override {inherit (config.boot.plymouth) theme;})];
  };
}
