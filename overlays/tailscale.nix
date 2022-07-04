final: prev: {
  tailscale = prev.tailscale.override {
    buildGoModule = args:
      final.buildGo118Module (args
        // {
          inherit (final.dan-nixpkgs.tailscale) pname src version;
          vendorSha256 = "sha256-8bRxQDth8Y9ggYkwgHTq0iAIB9wSGoV6/sKZDeFeGHY=";
        });
  };
}
