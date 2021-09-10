final: prev: {
  manix = prev.manix.overrideAttrs (o: {
    inherit (final.sources.manix) pname version src;
  });
}
