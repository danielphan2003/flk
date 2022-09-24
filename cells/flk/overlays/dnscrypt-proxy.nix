final: prev: {
  dnscrypt-proxy2 = prev.dnscrypt-proxy2.override {
    buildGoModule = attrs: let
      overrideAttrs = {
        inherit (final.fog.dnscrypt-proxy2) pname src version;
        vendorSha256 = null;
      };
    in
      final.buildGoModule (attrs // overrideAttrs);
  };
}
