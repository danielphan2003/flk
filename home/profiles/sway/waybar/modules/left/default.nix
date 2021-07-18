args@{ pkgs, lib, ... }:
let
  inherit (lib.our) mkWaybarModule;

  mediaplayer = mkWaybarModule ./mediaplayer.nix { inherit pkgs; };

  play-pause = pkgs.callPackage ./play-pause.nix { };

  media = player: icon:
    let
      patternNotDefault = "'^(?!firefox|spotify|vlc)([a-z0-9]+)'";
      checkPlayer = "${pkgs.playerctl}/bin/playerctl -l";
      checkIfNotDefault = '' [ "$(${checkPlayer} | ${pkgs.ripgrep}/bin/rg --pcre2 ${patternNotDefault})" ] '';
      checkIfDefault = '' [ "$(${checkPlayer} | ${pkgs.gnugrep}/bin/grep ${player})" ] '';
    in
    {
      format = "{icon} {}";
      return-type = "json";
      max-length = 55;
      format-icons = {
        Playing = "";
        Paused = "";
      };
      exec = "${mediaplayer} ${player} ${icon}";
      exec-if = "${checkIfNotDefault} || ${checkIfDefault}";
      interval = 1;
      on-click = "${play-pause} ${player}";
    };
in
{
  modules-left = [
    "sway/workspaces"
    "sway/mode"
    "custom/media#firefox"
    "custom/media#spotify"
    "custom/media#vlc"
    "custom/media#other"
  ];
  modules = {
    "sway/workspaces" = {
      all-outputs = true;
      format = "{icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "";
        "9" = "";
        "10" = "";
        "22" = "";
        focused = "";
        urgent = "";
        default = "";
      };
    };
    "custom/media#firefox" = media "firefox" "";
    "custom/media#spotify" = media "spotify" "";
    "custom/media#vlc" = media "vlc" "嗢";
    "custom/media#other" = media "other" "";
  };
}
