{ pkgs, ... }:
let inherit (builtins) attrValues; in
{
  programs.obs-studio = {
    enable = true;
    plugins = attrValues {
      inherit (pkgs.obs-studio-plugins)
        obs-gstreamer
        wlrobs
        ;
    };
  };
}
