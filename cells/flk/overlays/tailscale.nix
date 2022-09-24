final: prev: {
  tailscale = prev.tailscale.override {
    buildGoModule = attrs: let
      overrideAttrs = {
        inherit (final.fog.tailscale) src version;
        vendorSha256 = "sha256-+7Cr7wmt4PheHJRAlyKhRd6QRIZBqrbVtn5I94h8lLo=";
      };
    in
      final.buildGo119Module (attrs // overrideAttrs);
  };
}
