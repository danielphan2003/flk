final: prev: {
  picom = prev.picom.overrideAttrs (o: {
    inherit (final.dan-nixpkgs.picom) pname version src;
  });
}
