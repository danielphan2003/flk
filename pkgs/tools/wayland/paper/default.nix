{ rustPlatform, lib, sources, makeWrapper, wayland }:
rustPlatform.buildRustPackage rec {
  inherit (sources.paper) pname version src cargoLock;

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/paper \
      --prefix LD_LIBRARY_PATH : "${wayland}/lib"
  '';

  meta = with lib; {
    description = "A wallpaper daemon for Wayland compositors implementing the layer-shell protocol.";
    homepage = "https://gitlab.com/snakedye/paper";
    maintainers = [ danielphan2003 ];
    license = licenses.mit;
  };
}
