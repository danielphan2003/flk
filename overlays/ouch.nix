final: prev: let
  rustPlatform = final.makeRustPlatform {inherit (final.fenix.stable) cargo rustc;};
in {
  ouch = prev.ouch.override {
    rustPlatform.buildRustPackage = args:
      rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
        // {
          inherit (final.dan-nixpkgs.ouch) pname src version;
          cargoLock = final.dan-nixpkgs.ouch.cargoLock."Cargo.lock";
        });
  };
}
