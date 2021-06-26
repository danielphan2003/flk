final: prev: {
  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (o: rec {
      inherit (prev.sources.sway-borders) pname version src;
    })).override { wlroots = final.waylandPkgs.wlroots; };
}
