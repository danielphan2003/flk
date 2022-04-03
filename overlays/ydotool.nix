final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  ydotool = prev.ydotool.overrideAttrs (_: {
    inherit (final.sources.ydotool) pname version src;
  });
}
