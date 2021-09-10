final: prev: {
  picom = prev.picom.overrideAttrs (o: {
    inherit (final.sources.picom) pname version src;
  });
}
