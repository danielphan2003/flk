final: prev: let
  inherit (final) fog;
in {
  cinny = builtins.throw "cinny now has a web version and a desktop version. Use them as cinny-web or cinny-desktop.";

  cinny-web = prev.cinny.overrideAttrs (_: {
    inherit (fog.cinny) src version;
  });

  matrix-appservice-discord = prev.matrix-appservice-discord.overrideAttrs (_: {
    inherit (fog.matrix-appservice-discord) src version;
    packageJSON = ../packages/servers/matrix-appservice-discord/package.json;
    yarnNix = ../packages/servers/matrix-appservice-discord/yarn-dependencies.nix;
  });

  matrix-conduit = prev.matrix-conduit.override {
    rustPlatform = {
      inherit (final.rustPlatform) bindgenHook;

      buildRustPackage = attrs: let
        inherit (final.fog.conduit) src version cargoLock;

        attrs' = builtins.removeAttrs attrs ["cargoSha256"];

        overrideAttrs = {
          inherit src version;
          cargoLock = cargoLock."Cargo.lock";
        };
      in
        final.rustPlatform.buildRustPackage (attrs' // overrideAttrs);
    };
  };
}
