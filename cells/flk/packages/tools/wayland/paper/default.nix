{
  rustPlatform,
  lib,
  fog,
  makeWrapper,
  pkg-config,
  fontconfig,
  wayland,
}:
rustPlatform.buildRustPackage {
  inherit (fog.paper) pname version src;

  cargoLock = fog.paper.cargoLock."Cargo.lock";

  nativeBuildInputs = [makeWrapper pkg-config];

  buildInputs = [fontconfig];

  postFixup = ''
    wrapProgram $out/bin/paper \
      --prefix LD_LIBRARY_PATH : "${wayland}/lib"
  '';

  meta = with lib; {
    description = "A wallpaper daemon for Wayland compositors implementing the layer-shell protocol.";
    homepage = "https://gitlab.com/snakedye/paper";
    license = licenses.mit;
    maintainers = [maintainers.danielphan2003];
  };
}
