final: prev: {
  flameshot = prev.flameshot.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.flameshot) pname src version;
    patches = [];
  });
}
