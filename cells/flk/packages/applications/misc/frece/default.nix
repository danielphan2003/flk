{
  rustPlatform,
  lib,
  fog,
}:
rustPlatform.buildRustPackage {
  inherit (fog.frece) pname version src;

  cargoLock = fog.frece.cargoLock."Cargo.lock";

  meta = with lib; {
    description = "Maintain a database sorted by frecency (frequency + recency) ";
    homepage = "https://github.com/YodaEmbedding/frece";
    license = licenses.mit;
    maintainers = [maintainers.danielphan2003];
  };
}
