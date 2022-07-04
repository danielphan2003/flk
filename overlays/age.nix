channels: final: prev: {
  age-plugin-yubikey = channels.nixpkgs.age-plugin-yubikey.override {
    # rustPlatform.buildRustPackage = args:
    #   final.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
    #     // {
    #       inherit (final.dan-nixpkgs.age-plugin-yubikey) src version cargoLock;
    #     });
  };
}
