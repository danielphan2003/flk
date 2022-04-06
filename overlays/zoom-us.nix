channels: final: prev: {
  zoom-us = prev.zoom-us.overrideAttrs (_: {
    inherit (final.sources.zoom-us) src version;
  });
}
