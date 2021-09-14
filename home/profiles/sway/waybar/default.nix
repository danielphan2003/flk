{ pkgs, lib, config, ... }:
let
  inherit (lib.our.pywal) mkWaybarColors;
  modules = import ./modules { inherit lib pkgs; };
in
{
  systemd.user.services.waybar = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waylandPkgs.waybar;
    systemd.enable = true;
    settings = [ (modules // { height = 40; }) ];
    style = mkWaybarColors {
      inherit config;
      style = ./style.css;
      pywalPath = "/home/danie/.cache/wal/colors-waybar.css";
      workspaces = 22;
    };
  };
}
