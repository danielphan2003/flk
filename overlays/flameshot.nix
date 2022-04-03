final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  flameshot = prev.flameshot.overrideAttrs (_: {
    inherit (final.sources.flameshot) pname src version;
    patches = [];
  });
}
