channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  eww = prev.eww.override {
    rustPlatform.buildRustPackage = args:
      final.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256"]
        // {
          inherit (final.sources.eww) src version cargoLock;
        });
  };

  eww-wayland = final.eww.override {withWayland = true;};
}
