final: prev: {
  flameshot = prev.flameshot.overrideAttrs (_: {
    inherit (final.fog.flameshot) pname src version;
    patches = [];
  });
}
