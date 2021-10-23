{ pkgs, ... }:
let inherit (builtins) attrValues; in
{
  programs.obs-studio = {
    enable = true;
    plugins = attrValues 
      ({
        inherit (pkgs.obs-studio-plugins)
          wlrobs
          ;
      }
    //
    (if pkgs.system != "aarch64-linux"
    then { inherit (pkgs.obs-studio-plugins) obs-gstreamer; }
    else { }));
  };
}
