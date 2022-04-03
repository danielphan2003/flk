final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  libsForQt5 =
    prev.libsForQt5
    // {
      sddm = prev.libsForQt5.sddm.overrideAttrs (_: {
        inherit (final.sources.sddm) src version;
        patches = prev.lib.our.getPatches ../pkgs/applications/display-managers/sddm;
      });
    };
}
