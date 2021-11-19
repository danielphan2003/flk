channels: final: prev:
let
  inherit (channels.latest) ouch fenix makeRustPlatform;
  rustPlatform = makeRustPlatform { inherit (fenix.latest) cargo rustc; };
in
{
  ouch = ouch.override {
    rustPlatform.buildRustPackage = args: rustPlatform.buildRustPackage (builtins.removeAttrs args [ "cargoSha256" ] // {
      inherit (final.sources.ouch) pname src version cargoLock;
    });
  };
}
