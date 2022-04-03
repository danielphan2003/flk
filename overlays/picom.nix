final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  picom = prev.picom.overrideAttrs (o: {
    inherit (final.sources.picom) pname version src;
  });
}
