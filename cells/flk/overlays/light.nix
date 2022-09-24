final: prev: {
  light = prev.light.overrideAttrs (_: {
    inherit (final.fog.light) pname src version;
    patches = [];
  });
}
