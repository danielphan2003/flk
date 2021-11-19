channels: final: prev: {
  tailscale = with channels.latest; callPackage
    ({ tailscale, hostName ? "ts-${prev.system}", customDoHPath ? null }: tailscale.override {
      buildGoModule = args: buildGo117Module (args // {
        inherit (final.sources.tailscale) pname src version;
        vendorSha256 = "sha256-n8uNvqPBmoGwjEuNOqTsvZ7U4TniMyfcnAQguyyGMOM=";
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
