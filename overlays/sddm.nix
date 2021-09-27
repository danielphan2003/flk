final: prev: {
  libsForQt5 = with prev; libsForQt5 // {
    sddm = libsForQt5.sddm.overrideAttrs (_: {
      inherit (final.sources.sddm) src version;
      patches = lib.our.getPatches ../pkgs/applications/display-managers/sddm;
    });
  };
}
