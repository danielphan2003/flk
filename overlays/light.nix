final: prev: {
  light = prev.light.overrideAttrs (o: {
    inherit (final.sources.light) pname src version;
  });
}
