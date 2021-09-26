channels: final: prev: {
  netdata = with channels.latest; (netdata.override {
    callPackage = args: deps: callPackage args (deps // {
      buildGoModule = goArgs: buildGoModule (goArgs // {
        inherit (final.sources.netdata-go-d-plugin) src version;
        vendorSha256 = "sha256-kfrP8cLnVn+akA9zwx10OBJ62PAoZAkG9ZiAxN+sR5M=";
      });
    });
  }).overrideAttrs (_: {
    inherit (final.sources.netdata) pname src version;
  });
}
