channels: final: prev: {
  rnix-lsp = channels.latest.rustPlatform.buildRustPackage
    rec {
      inherit (final.sources.rnix-lsp) pname version src cargoLock;

      inherit (channels.latest.rnix-lsp) meta;
    } // {
    meta.maintainers = with prev.lib.maintainers; [ danielphan2003 ];
  };
}
