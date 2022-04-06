channels: final: prev: {
  duf = let
    duf' = {
      buildGoModule,
      duf,
      sources,
    }:
      duf.override {
        buildGoModule = args:
          buildGoModule (args
            // {
              inherit (sources.duf) pname src version;
              vendorSha256 = "sha256-oihi7E67VQmym9U1gdD802AYxWRrSowhzBiKg0CBDPc=";
            });
      };
  in
    final.callPackage duf' {inherit (prev) duf;};
}
