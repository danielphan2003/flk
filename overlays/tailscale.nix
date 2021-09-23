channels: final: prev:
let
  buildGo117Module = with channels.latest; buildGoModule.override {
    go = go_1_17;
  };
in
{
  tailscale = channels.latest.tailscale.override {
    buildGoModule = args: buildGo117Module (args // {
      inherit (final.sources.tailscale) pname src version;
      vendorSha256 = "sha256-93fdlHlYLtzoAu96HEf9X4JOzMGDZ5h7rdeR6xQFCsc=";
    });
    lib = with prev; lib // {
      # see https://github.com/NixOS/nixpkgs/pull/124429
      makeBinPath = args: lib.makeBinPath (args ++ [ sysctl ]);
    };
  };
}
