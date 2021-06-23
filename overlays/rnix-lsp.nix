final: prev:
{
  rnix-lsp = let src = final.srcs.rnix-lsp; in
    prev.rustPlatform.buildRustPackage rec {
      pname = "rnix-lsp";
      inherit src;
      inherit (src) version;

      cargoLock.lockFile = src + "/Cargo.lock";

      meta = with prev.lib; {
        description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
        license = licenses.mit;
        maintainers = with maintainers; [ jD91mZM2 danielphan2003 ];
      };
    };
}
