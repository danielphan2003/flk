final: prev:
let
  caddyPackage =
    { buildGoModule
    , lib
    , sources
    , caddy
    , plugins ? [ ]
    , vendorSha256 ? "sha256-oNJA0lU6PqArLCuPBiyV9Vaps0Q3ZpVg2cMIPxUfpqg="
    }:
    prev.buildGoModule rec {
      inherit (sources.caddy) pname src version;

      imports = lib.flip lib.concatMapStrings plugins (plugin: "_ \"${plugin}\"\n");

      main = ''
        package main

        import (
          caddycmd "github.com/caddyserver/caddy/v2/cmd"
          _ "github.com/caddyserver/caddy/v2/modules/standard"
          ${imports}
        )

        func main() {
          caddycmd.Main()
        }
      '';

      inherit vendorSha256;

      overrideModAttrs = (_: {
        prePatch = "echo '${main}' > cmd/caddy/main.go";
        postInstall = "cp go.sum go.mod $out";
      });

      postPatch = "echo '${main}' > cmd/caddy/main.go";

      postConfigure = ''
        cp vendor/go.sum ./
        cp vendor/go.mod ./
      '';

      inherit (caddy) passthru meta;
    };
in
{
  caddy = final.callPackage caddyPackage { inherit (prev) caddy; };
}
