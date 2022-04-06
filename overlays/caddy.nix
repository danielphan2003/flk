channels: final: prev: {
  caddy = let
    caddy' = {
      buildGoModule,
      lib,
      sources,
      caddy,
      plugins ? [],
      vendorSha256 ? "sha256-XUyKCttOpIMKgaVHJ9JApjItYFEJYxMyoWSYNKv5Elg=",
    }: let
      imports = lib.flip lib.concatMapStrings plugins (pkg: ''_ "${pkg}"'' + "\n");

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
    in
      caddy.override {
        buildGoModule = args:
          buildGoModule (args
            // {
              inherit (sources.caddy) src version;

              inherit vendorSha256 main;

              pname = args.pname + lib.optionalString (plugins != []) "-with-plugins";

              overrideModAttrs = o: {
                prePatch = ''echo '${main}' > cmd/caddy/main.go'';
                postInstall = ''
                  ${o.postInstall or ""}
                  cp go.sum go.mod "$out"
                '';
              };

              postPatch = ''echo "$main" > cmd/caddy/main.go'';

              postConfigure = ''cp vendor/go.{sum,mod} .'';
            });
      };
  in
    final.callPackage caddy' {inherit (channels.latest) caddy;};
}
