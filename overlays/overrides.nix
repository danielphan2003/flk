channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  inherit
    (channels.nixpkgs)
    argononed
    nix
    nix-du
    ;

  # obs-studio-plugins =
  #   prev.obs-studio-plugins
  #   // {
  #     wlrobs = final.obs-wlrobs;
  #   };

  androidenv.androidPkgs_9_0.platform-tools = final.android-tools;
}
