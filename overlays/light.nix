final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  light = prev.light.overrideAttrs (o: {
    inherit (final.sources.light) pname src version;
  });
}
