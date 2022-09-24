{
  lib,
  buildGoApplication,
  fog,
  nixosTests,
  substituteAll,
  plugins ? [],
  vendorSha256 ? "",
}: let
  inherit (fog.caddy) pname src;

  dist = fog.caddy-dist.src;

  version = lib.removePrefix "v" fog.caddy.version;

  imports = lib.flip lib.concatMapStrings plugins (pkg: ''_ "${pkg}"'' + "\n");

  main = substituteAll {
    inherit imports;
    src = ./main.go;
  };
in
  buildGoApplication {
    inherit pname src version vendorSha256;

    modules = ./gomod2nix.toml;

    subPackages = ["cmd/caddy"];

    doCheck = false;

    prePatch = lib.optionalString (plugins != []) ''
      ln -sf ${main} cmd/caddy/main.go
    '';

    postInstall = ''
      install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

      substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
      substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"
    '';

    passthru.tests = {inherit (nixosTests) caddy;};

    meta = with lib; {
      homepage = "https://caddyserver.com";
      description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
      license = licenses.asl20;
      maintainers = with maintainers; [Br1ght0ne techknowlogick];
    };
  }
