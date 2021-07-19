{ rustPlatform, lib, sources, wayland }:
rustPlatform.buildRustPackage rec {
  inherit (sources.paper) pname version src cargoLock;

  buildInputs = [ wayland ];

  postInstall = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/paper
  '';

  meta = with lib; {
    description = "A wallpaper daemon for Wayland compositors implementing the layer-shell protocol.";
    maintainers = [ danielphan2003 ];
  };
}
