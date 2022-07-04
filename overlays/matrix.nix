final: prev: let
  inherit (final) dan-nixpkgs;
in {
  cinny = builtins.throw "cinny now has a web version and a desktop version. Use them as cinny-web or cinny-desktop.";

  cinny-web = prev.cinny.overrideAttrs (_: {
    inherit (dan-nixpkgs.cinny) src version;
  });

  matrix-appservice-discord = prev.matrix-appservice-discord.overrideAttrs (_: {
    inherit (dan-nixpkgs.matrix-appservice-discord) src version;
    packageJSON = ../pkgs/servers/matrix-appservice-discord/package.json;
    yarnNix = ../pkgs/servers/matrix-appservice-discord/yarn-dependencies.nix;
  });

  matrix-conduit = let
    inherit (final.dan-nixpkgs.conduit) src version cargoLock;
  in
    prev.matrix-conduit.override {
      rustPlatform =
        final.rustPlatform
        // {
          buildRustPackage = args:
            final.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
              // {
                inherit src version;
                cargoLock = cargoLock."Cargo.lock";
              });
        };
    };
}
