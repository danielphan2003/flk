final: prev: {
  flameshot = prev.flameshot.overrideAttrs (_: {
    inherit (final.sources.flameshot) pname src version;
    patches = [ ];
  });
}
