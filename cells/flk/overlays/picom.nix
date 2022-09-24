final: prev: {
  picom = prev.picom.overrideAttrs (o: {
    inherit (final.fog.picom) pname version src;
  });
}
