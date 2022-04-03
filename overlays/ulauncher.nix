channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  ulauncher = prev.ulauncher.overrideAttrs (_: {
    inherit (final.sources.ulauncher) src version;
    patches = prev.lib.our.getPatches ../pkgs/applications/misc/ulauncher;
  });
}
