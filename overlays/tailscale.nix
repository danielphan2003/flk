channels: final: prev: {
  # __dontExport = true; # overrides clutter up actual creations

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
              vendorSha256 = "sha256-Wa+P/jSDwVTbBMY42/vreGZNwy9AsxgPbXTUz2tyYEc=";
            });
      };
  in
    final.callPackage tailscale' {
      inherit (prev) tailscale;
      inherit (channels.latest) buildGo118Module;
    };
}
