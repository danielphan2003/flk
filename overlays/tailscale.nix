channels: final: prev:
let buildGo117Module = with channels.latest; buildGoModule.override { go = go_1_17; }; in
{
  tailscale = with channels.latest; callPackage
    ({ tailscale, hostName ? "ts-${prev.system}", customDoHPath ? null }: tailscale.override {
      buildGoModule = args: buildGo117Module (args // {
        inherit (final.sources.tailscale) pname src version;
        vendorSha256 = "sha256-QyGnPcM/KzSexULcww6P4E5WWAA1eVrsQfJs41tHlG0=";
        patches = [ ]
          ++
          (if customDoHPath != null
          then
            [
              (substituteAll {
                src = ../pkgs/servers/tailscale/custom-doh.patch;
                inherit hostName customDoHPath;
              })
            ]
          else [ ]);
      });
    })
    { };
}
