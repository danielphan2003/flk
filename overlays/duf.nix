final: prev: {
  duf = with prev; duf.override {
    buildGoModule = args: buildGoModule (args // {
      inherit (final.sources.duf) pname src version;
      vendorSha256 = "sha256-Ma1Jr8/ltKBbEbpA/xRwMKEe7NgcHUTiUUuGu5BZGks=";
    });
  };
}
