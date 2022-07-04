{
  rustPlatform,
  lib,
  dan-nixpkgs,
}:
rustPlatform.buildRustPackage {
  inherit (dan-nixpkgs.frece) pname version src;

  cargoLock = dan-nixpkgs.frece.cargoLock."Cargo.lock";

  meta = with lib; {
    description = "Maintain a database sorted by frecency (frequency + recency) ";
    homepage = "https://github.com/YodaEmbedding/frece";
    license = licenses.mit;
    maintainers = [maintainers.danielphan2003];
  };
}
