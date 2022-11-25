final: prev: {
  tailscale = prev.tailscale.override {
    buildGoModule = attrs: let
      overrideAttrs = {
        inherit (final.fog.tailscale) src version;
        vendorSha256 = "sha256-fbRdC98V55KqzlkJRqTcjsqod4CUYL2jDgXxRmwvfSE=";
      };
    in
      final.buildGo119Module (attrs // overrideAttrs);
  };
}
