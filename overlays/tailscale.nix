channels: final: prev: {
  tailscale =
    let
      tailscale' =
        { buildGo117Module
        , sources
        , tailscale
        , substituteAll

        , hostName ? "ts-${prev.system}"
        , customDoHPath ? null
        }: tailscale.override {
          buildGoModule = args: buildGo117Module (args // {
            inherit (sources.tailscale) pname src version;
            vendorSha256 = "sha256-ZbOxC8J843B8BMS/ZgfSZqU1YCUoWhPqbABzWZy3DMI=";
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
        };
    in
    final.callPackage tailscale' { inherit (prev) tailscale; };
}
