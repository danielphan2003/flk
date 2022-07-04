final: prev: {
  vaultwarden = prev.vaultwarden.override {
    rustPlatform =
      prev.rustPlatform
      // {
        buildRustPackage = args:
          prev.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
            // {
              inherit (final.dan-nixpkgs.vaultwarden) src version;
              cargoLock = final.dan-nixpkgs.vaultwarden.cargoLock."Cargo.lock";
            });
      };
  };
  vaultwarden-vault = prev.vaultwarden-vault.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.vaultwarden-vault) src version;
  });
}
