{
  rustPlatform,
  lib,
  sources,
}:
rustPlatform.buildRustPackage {
  inherit (sources.frece) pname version src cargoLock;

  meta = with lib; {
    description = "Maintain a database sorted by frecency (frequency + recency) ";
    homepage = "https://github.com/YodaEmbedding/frece";
    license = licenses.mit;
    maintainers = [danielphan2003];
  };
}
