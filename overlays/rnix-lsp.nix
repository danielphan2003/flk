final: prev: {
  rnix-lsp = prev.rustPlatform.buildRustPackage rec {
    inherit (prev.sources.rnix-lsp) pname version src;

    cargoSha256 = "sha256-W4zSmr0veA25JvoUu2zb7gnS6Z0RutYQcHxV71k9jA4=";

    meta = with prev.lib; {
      description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
      license = licenses.mit;
      maintainers = [ danielphan2003 ];
    };
  };
}