{ buildGoModule
, lib
, sources
, makeWrapper
, nssTools
, nixosTests

, plugins ? [ ]
, vendorSha256 ? "sha256-oNJA0lU6PqArLCuPBiyV9Vaps0Q3ZpVg2cMIPxUfpqg="
}:
let
  imports = lib.flip lib.concatMapStrings plugins (pkg: "_ \"${pkg}\"\n");

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
buildGoModule rec {
  inherit (sources.caddy) src version;
  inherit vendorSha256;

  pname = "caddy${lib.optionalString (plugins != [ ]) "-with-plugins"}";

  nativeBuildInputs = [ makeWrapper ];

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

  postInstall = ''
    wrapProgram $out/bin/caddy \
      --prefix PATH : ${lib.makeBinPath [ nssTools ]}
  '';

  passthru.tests = { inherit (nixosTests) caddy; };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ danielphan2003 ];
  };
}
