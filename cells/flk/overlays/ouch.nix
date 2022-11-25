final: prev: {
  ouch = prev.ouch.override {
    rustPlatform.buildRustPackage = attrs: let
      attrs' = builtins.removeAttrs attrs ["cargoSha256" "nativeBuildInputs" "GEN_COMPLETIONS"];

      overrideAttrs = {
        inherit (final.fog.ouch) pname src version;
        cargoLock = final.fog.ouch.cargoLock."Cargo.lock";
        nativeBuildInputs = [final.installShellFiles final.pkg-config];
        postInstall = ''
          installManPage artifacts/*.1
          installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
        '';
        OUCH_ARTIFACTS_FOLDER = "artifacts";
        meta.changelog = "https://github.com/ouch-org/ouch/blob/${final.fog.ouch.version}/CHANGELOG.md";
      };
    in
      final.rustPlatform.buildRustPackage (final.lib.recursiveUpdate attrs' overrideAttrs);
  };
}
