channels: final: prev: {
  rnix-lsp = channels.latest.rustPlatform.buildRustPackage rec {
    inherit (final.sources.rnix-lsp) pname version src cargoLock;

    meta = with prev.lib; {
      description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
      license = licenses.mit;
      maintainers = [ danielphan2003 ];
    };
  };
}
