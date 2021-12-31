final: prev: {
  duf =
    let
      duf' =
        { buildGoModule
        , duf
        , sources
        }:
        duf.override {
          buildGoModule = args: buildGoModule (args // {
            inherit (sources.duf) pname src version;
            vendorSha256 = "sha256-6PV/v+rk63FIR2M0Q7EzqjVvWIwHtK6TQpEYxkXLQ50=";
          });
        };
    in
    final.callPackage duf' { inherit (prev) duf; };
}
