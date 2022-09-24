final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  # inherit
  #   (channels.nixpkgs)
  #   argononed
  #   nix
  #   nix-du
  #   nixos-rebuild
  #   ;

  # obs-studio-plugins =
  #   prev.obs-studio-plugins
  #   // {
  #     wlrobs = final.obs-wlrobs;
  #   };
}
