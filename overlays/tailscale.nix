final: prev: {
  tailscale = prev.tailscale.override {
    buildGoModule = args:
      final.buildGo118Module (args
        // {
          inherit (final.dan-nixpkgs.tailscale) pname src version;
          vendorSha256 = "sha256-d4DSi+DEN8nCSNQ1Sy277wg1FwMWiF0YzcLuVPM5m1s=";
        });
  };
}
