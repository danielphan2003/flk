channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  nwg-drawer = prev.nwg-drawer.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [prev.gdk-pixbuf];
  });
}
