final: prev: {
  vaultwarden = prev.vaultwarden.override {
    rustPlatform.buildRustPackage = attrs: let
      attrs' = builtins.removeAttrs attrs ["cargoSha256"];

      overrideAttrs = {
        inherit (final.fog.vaultwarden) src version;
        cargoLock = final.fog.vaultwarden.cargoLock."Cargo.lock";
      };
    in
      final.rustPlatform.buildRustPackage (attrs' // overrideAttrs);
  };

  vaultwarden-vault = prev.vaultwarden-vault.overrideAttrs (_: {
    inherit (final.fog.vaultwarden-vault) src version;
  });
}
