final: prev: {
  inherit (final.waylandPkgs) xdg-desktop-portal-wlr;

  waylandPkgs = prev.waylandPkgs // {

    sway-unwrapped = prev.waylandPkgs.sway-unwrapped.overrideAttrs (_: rec {
      inherit (prev.sources.sway-borders) pname version src;
    });

  };

  swaylock-effects = prev.swaylock-effects.overrideAttrs (_: rec {
    inherit (prev.sources.swaylock-effects) pname version src;
  });

  sway = prev.sway.override { inherit (final.waylandPkgs) sway-unwrapped; };
}
