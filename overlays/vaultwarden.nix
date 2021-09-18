channels: final: prev: with channels.latest; {
  vaultwarden = vaultwarden.override {
    rustPlatform = rustPlatform // {
      buildRustPackage = args:
        rustPlatform.buildRustPackage (builtins.removeAttrs args [ "cargoSha256" ] // {
          inherit (final.sources.vaultwarden) src version cargoLock;
        });
    };
  };
  vaultwarden-vault = vaultwarden-vault.overrideAttrs (_: {
    inherit (final.sources.vaultwarden-vault) src version;
  });
}
