final: prev: {
  libsForQt5 = let
    libsForQt5' = {
      sddm = prev.libsForQt5.sddm.overrideAttrs (_: {
        inherit (final.fog.sddm) src version;
        patches = prev.lib.flk.getPatchFiles ../packages/applications/display-managers/sddm;
      });
    };
  in
    prev.libsForQt5 // libsForQt5';
}
