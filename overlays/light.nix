final: prev: {
  light = prev.light.overrideAttrs (o: rec {
    inherit (final.sources.light) pname src version;
  });
}
