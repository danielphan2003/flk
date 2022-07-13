channels: final: prev: {
  duf = prev.duf.override {
    buildGoModule = args:
      final.buildGoModule
      (args
        // {
          inherit (final.dan-nixpkgs.duf) pname src version;
          vendorSha256 = "sha256-T12lPLqipfYvs9cigX2MlG/q+87XUBlxstAqH4+HYos=";
        });
  };
}
