final: prev: {
  eww = prev.eww.override {
    rustPlatform.buildRustPackage = attrs: let
      inherit (final.fog.eww) src version cargoLock;

      attrs' = builtins.removeAttrs attrs ["cargoSha256"];

      overrideAttrs = {
        inherit src version;
        cargoLock = cargoLock."Cargo.lock";
        cargoPatches = [];
      };
    in
      final.rustPlatform.buildRustPackage (attrs' // overrideAttrs);
  };

  eww-wayland = final.eww.override {withWayland = true;};
}
