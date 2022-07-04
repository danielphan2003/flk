final: prev: {
  zoom-us = prev.zoom-us.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.zoom-us) src version;
  });
}
