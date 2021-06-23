# broken
{ srcs, lib, rustPlatform, cmake, pkg-config, freetype, expat }:
let inherit (srcs) waycorner; in
rustPlatform.buildRustPackage rec {
  pname = "waycorner";

  inherit (waycorner) version;

  src = waycorner;

  cargoLock.lockFile = src + "/Cargo.lock";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ freetype expat ];

  cargoBuildFlags = [ "--all-features" ];

  prePatch = ''
    echo $MAKEFLAGS
    echo $CARGO_MAKEFLAGS
    make -R -f makefile.cargo
  '';

  doCheck = false;

  meta = with lib; {
    description = "Hot corners for Wayland. Create anchors in the corners of your monitors and execute a command of your choice.";
    license = licenses.mit;
    maintainers = with maintainers; [ danielphan2003 ];
  };
}