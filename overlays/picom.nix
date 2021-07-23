final: prev: {
  picom = prev.picom.overrideAttrs (o: rec{
    inherit (final.sources.picom) pname version src;
  });
}
