final: prev: {
  ydotool = prev.ydotool.overrideAttrs (_: {
    inherit (final.fog.ydotool) pname version src;
  });
}
