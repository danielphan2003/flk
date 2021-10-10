channels: final: prev:
let buildGo117Module = with channels.latest; buildGoModule.override { go = go_1_17; }; in
{
  tailscale = channels.latest.tailscale.override {
    buildGoModule = args: buildGo117Module (args // {
      inherit (final.sources.tailscale) pname src version;
      vendorSha256 = "sha256-8WN9BsLVYk3mb1cQkFxDoN+OynIUV1zSLcF1l8+Ijdc=";
    });
  };
}
