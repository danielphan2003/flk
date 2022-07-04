final: prev: {
  ydotool = prev.ydotool.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.ydotool) pname version src;
  });
}
