channels: final: prev: {
  age-plugin-yubikey = channels.latest.age-plugin-yubikey.override {
    rustPlatform.buildRustPackage = args:
      final.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
        // {
          inherit (final.sources.age-plugin-yubikey) src version cargoLock;
        });
  };
}
