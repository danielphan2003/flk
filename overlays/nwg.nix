final: prev: {
  nwg-drawer = prev.nwg-drawer.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [final.gdk-pixbuf];
  });
}
