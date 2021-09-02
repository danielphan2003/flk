channels: final: prev: {
  tailscale = channels.latest.tailscale.overrideAttrs (_: {
    inherit (final.sources.tailscale) pname src version;
    vendorSha256 = prev.lib.fakeSha256;
  });
}
