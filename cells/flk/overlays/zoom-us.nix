final: prev: {
  zoom-us = prev.zoom-us.overrideAttrs (_: {
    inherit (final.fog.zoom-us) src version;
  });
}
