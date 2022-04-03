channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  vaultwarden = prev.vaultwarden.override {
    rustPlatform =
      prev.rustPlatform
      // {
        buildRustPackage = args:
          prev.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
            // {
              inherit (final.sources.vaultwarden) src version cargoLock;
            });
      };
  };
  vaultwarden-vault = prev.vaultwarden-vault.overrideAttrs (_: {
    inherit (final.sources.vaultwarden-vault) src version;
  });
}
