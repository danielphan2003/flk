final: prev: {
  dnscrypt-proxy2 = prev.dnscrypt-proxy2.override {
    buildGoModule = args:
      final.buildGoModule
      (args
        // {
          inherit (final.dan-nixpkgs.dnscrypt-proxy2) pname src version;
          vendorSha256 = null;
        });
  };
}
