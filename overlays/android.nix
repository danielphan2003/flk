final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  # waydroid = prev.waydroid.overrideAttrs (_: {
  #   inherit (final.sources.waydroid) src version;
  #   patches = prev.lib.our.getPatches ../pkgs/os-specific/linux/waydroid;
  # });
}
