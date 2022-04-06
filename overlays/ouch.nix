channels: final: prev: let
  inherit (final) fenix makeRustPlatform;
  rustPlatform = makeRustPlatform {inherit (fenix.stable) cargo rustc;};
in {
  ouch = prev.ouch.override {
    rustPlatform.buildRustPackage = args:
      rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
        // {
          inherit (final.sources.ouch) pname src version cargoLock;
        });
  };
}
