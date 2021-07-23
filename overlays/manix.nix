final: prev: {
  manix = prev.manix.overrideAttrs (o: rec{
    inherit (final.sources.manix) pname version src;
  });
}
