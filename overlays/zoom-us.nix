channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  zoom-us = prev.zoom-us.overrideAttrs (_: {
    inherit (final.sources.zoom-us) src version;
  });
}
