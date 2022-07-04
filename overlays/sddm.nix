final: prev: {
  libsForQt5 =
    prev.libsForQt5
    // {
      sddm = prev.libsForQt5.sddm.overrideAttrs (_: {
        inherit (final.dan-nixpkgs.sddm) src version;
        patches = prev.lib.our.getPatches ../pkgs/applications/display-managers/sddm;
      });
    };
}
