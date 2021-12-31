channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels) latest;

  obs-studio-plugins = prev.obs-studio-plugins // {
    wlrobs = final.waylandPkgs.obs-wlrobs;
  };

  androidenv.androidPkgs_9_0.platform-tools = final.android-tools;

}
