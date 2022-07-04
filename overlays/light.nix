final: prev: {
  light = prev.light.overrideAttrs (o: {
    inherit (final.dan-nixpkgs.light) pname src version;
  });
}
