final: prev: {
  eww = prev.eww.override {
    rustPlatform.buildRustPackage = args:
      final.rustPlatform.buildRustPackage
      (builtins.removeAttrs args ["cargoSha256"]
        // {
          inherit (final.dan-nixpkgs.eww) src version;
          cargoLock = final.dan-nixpkgs.eww.cargoLock."Cargo.lock";
        });
  };

  eww-wayland = final.eww.override {withWayland = true;};
}
