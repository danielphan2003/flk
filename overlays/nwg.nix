channels: final: prev: {
  nwg-drawer = channels.latest.nwg-drawer.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ (with prev; [ gdk-pixbuf ]);
  });
}
