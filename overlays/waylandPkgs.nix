final: prev: {
  waylandPkgs = prev.waylandPkgs // {
    sway-unwrapped = prev.waylandPkgs.sway-unwrapped.overrideAttrs (o: rec {
      inherit (prev.sources.sway-borders) pname version src;
    });
    waybar = prev.waylandPkgs.waybar.overrideAttrs (o: rec{
      inherit (prev.sources.waybar) pname version src;
    });
  };
  sway = prev.sway.override { inherit (final.waylandPkgs) sway-unwrapped; };
}
