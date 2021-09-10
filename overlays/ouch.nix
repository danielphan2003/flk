channels: final: prev: {
  ouch = channels.latest.rustPlatform.buildRustPackage {
    inherit (final.sources.ouch) pname src version cargoLock;
    inherit (channels.latest.ouch) meta;
  };
}
