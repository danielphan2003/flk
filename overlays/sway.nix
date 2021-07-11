final: prev: {
  meson-for-sway = prev.meson.overrideAttrs(o: rec {
    inherit (final.sources.meson) version src;
    meta.version = version;
  });

  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (o: rec {
      inherit (prev.sources.sway-borders) pname version src;
    })).override {
      meson = final.meson-for-sway;
      inherit (final.waylandPkgs) wlroots;
    };
}
