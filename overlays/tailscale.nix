channels: final: prev: {
  tailscale = let
    tailscale' = {
      buildGo118Module,
      sources,
      tailscale,
    }:
      tailscale.override {
        buildGoModule = args:
          buildGo118Module (args
            // {
              inherit (sources.tailscale) pname src version;
              vendorSha256 = "sha256-5on+6kPmEY0wIz84wKfWEdS7/aMzbLSqM/8vIHuLxNQ=";
            });
      };
  in
    final.callPackage tailscale' {
      inherit (prev) tailscale;
      inherit (channels.latest) buildGo118Module;
    };
}
