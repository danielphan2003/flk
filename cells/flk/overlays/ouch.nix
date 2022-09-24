final: prev: {
  ouch = prev.ouch.override {
    rustPlatform.buildRustPackage = attrs: let
      rustPlatform = final.makeRustPlatform {inherit (final.fenix.stable) cargo rustc;};

      attrs' = builtins.removeAttrs attrs ["cargoSha256"];

      overrideAttrs = {
        inherit (final.fog.ouch) pname src version;
        cargoLock = final.fog.ouch.cargoLock."Cargo.lock";
      };
    in
      rustPlatform.buildRustPackage (attrs' // overrideAttrs);
  };
}
