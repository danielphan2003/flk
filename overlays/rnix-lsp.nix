final: prev: {
  rnix-lsp = prev.rustPlatform.buildRustPackage {
    inherit (prev.sources.rnix-lsp) pname version src;
    inherit (prev.sources.rnix-lsp.cargoLock) lockFile;

    cargoSha256 = "sha256-+XUWD/Gh31+oW4pXsFtrbN6z91pDG44+yiWyCEH44bc=";

    meta = with prev.lib; {
      description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
      license = licenses.mit;
      maintainers = [ danielphan2003 ];
    };
  };
}
