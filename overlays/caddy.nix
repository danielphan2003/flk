final: prev: {
  caddy =
    let
      inherit (prev.lib) flip concatMapStrings;
      src = final.srcs.caddy;
    in
    prev.buildGoModule rec {
      pname = "caddy";
      inherit src;
      inherit (src) version;

      plugins = [
        "github.com/caddy-dns/duckdns"
      ];

      imports = flip concatMapStrings plugins (pkg: "_ \"${pkg}\"\n");

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

      vendorSha256 = "sha256-vXWe/9GZfdmDaS0wnhc0v7QWH4YFCOnHzLwer2Uz/jE=";

      overrideModAttrs = (_: {
        prePatch = "echo '${main}' > cmd/caddy/main.go";
        postInstall = ''
          cp go.sum go.mod $out
          ls $out
        '';
      });

      postPatch = ''
        echo '${main}' > cmd/caddy/main.go
        cat cmd/caddy/main.go
      '';

      postConfigure = ''
        cp vendor/go.sum ./
        cp vendor/go.mod ./
      '';

      passthru = prev.caddy.passthru;

      meta = prev.caddy.meta;
    };
}
