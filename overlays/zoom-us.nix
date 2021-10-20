channels: final: prev: {
  zoom-us = channels.latest.zoom-us.overrideAttrs (_: {
    inherit (final.sources.zoom-us) src version;
  });
}
