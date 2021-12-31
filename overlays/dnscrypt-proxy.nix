channels: final: prev: {
  dnscrypt-proxy2 = prev.dnscrypt-proxy2.override {
    buildGoModule = args: prev.buildGoModule (args // {
      inherit (final.sources.dnscrypt-proxy2) pname src version;
      vendorSha256 = null;
    });
  };
}
