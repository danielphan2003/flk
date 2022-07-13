channels: final: prev: {
  caddy = let
    caddy' = {
      buildGoModule,
      lib,
      dan-nixpkgs,
      caddy,
      plugins ? [],
      vendorSha256 ? lib.fakeSha256,
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
      if plugins == []
      then caddy
      else
        caddy.override {
          buildGoModule = args:
            buildGoModule
            (args
              // {
                # inherit (dan-nixpkgs.caddy) src version;

                inherit vendorSha256;

                passthru.plugins = plugins;

                pname = "${args.pname}-with-plugins";

                overrideModAttrs = _: {
                  preBuild = "echo '${main}' > cmd/caddy/main.go";
                  postInstall = "cp go.sum go.mod $out";
                };

                postPatch = ''
                  echo '${main}' > cmd/caddy/main.go
                  cat cmd/caddy/main.go
                '';

                postConfigure = ''
                  cp vendor/go.sum ./
                  cp vendor/go.mod ./
                '';

                doCheck = false;
              });
        };
  in
    final.callPackage caddy' {inherit (prev) caddy;};
}
