final: prev: {
  ydotool = prev.ydotool.overrideAttrs (_: {
    inherit (final.sources.ydotool) pname version src;
  });
}
