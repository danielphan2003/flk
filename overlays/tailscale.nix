channels: final: prev:
let
  inherit (channels.go117) go_1_17;
  buildGo117Module = channels.latest.buildGoModule.override {
    go = go_1_17;
  };
in
{
  tailscale = channels.latest.tailscale.override {
    buildGoModule = args: buildGo117Module (args // {
      inherit (final.sources.tailscale) pname src version;
      vendorSha256 = "sha256-6oAnSkAmfM1B2RoY6VSH4BZYbQr9HFzyG7vRZfbIYBo=";
    });
  };
}
