channels: final: prev: let
  inherit (final) sources;

  inherit
    (prev)
    matrix-appservice-discord
    ;
in {
  cinny = channels.latest.cinny.overrideAttrs (_: {
    inherit (final.sources.cinny) src version;
  });

  matrix-appservice-discord = matrix-appservice-discord.overrideAttrs (_: {
    inherit (sources.matrix-appservice-discord) src version;
    packageJSON = ../pkgs/servers/matrix-appservice-discord/package.json;
    yarnNix = ../pkgs/servers/matrix-appservice-discord/yarn-dependencies.nix;
  });

  matrix-conduit = channels.latest.matrix-conduit;

  # matrix-conduit =
  #   let
  #     matrix-conduit' =
  #       { matrix-conduit
  #       , rustPlatform
  #       , lib
  #       , sources
  #       }:
  #       matrix-conduit.override {
  #         rustPlatform.buildRustPackage = args:
  #           rustPlatform.buildRustPackage (builtins.removeAttrs args [ "cargoSha256" ] // {
  #             inherit (sources.conduit) src version cargoLock;
  #             pname = "matrix-${sources.conduit.pname}";
  #           });
  #       };
  #   in
  #   final.callPackage matrix-conduit' { inherit (channels.latest) matrix-conduit rustPlatform; };
}
