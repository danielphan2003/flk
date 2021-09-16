{ rustPlatform, lib, sources, makeWrapper, pkg-config, fontconfig, wayland }:
rustPlatform.buildRustPackage {
  inherit (sources.paper) pname version src cargoLock;

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ fontconfig ];

  prePatch = ''
    substituteInPlace Cargo.toml \
      --replace 'git="https://gitlab.com/snakedye/snui.git"' 'path = "${sources.snui.src}"'
  '';

  postFixup = ''
    wrapProgram $out/bin/paper \
      --prefix LD_LIBRARY_PATH : "${wayland}/lib"
  '';

  meta = with lib; {
    description = "A wallpaper daemon for Wayland compositors implementing the layer-shell protocol.";
    homepage = "https://gitlab.com/snakedye/paper";
    license = licenses.mit;
    maintainers = [ danielphan2003 ];
  };
}
