{ lib, stdenv, pkgconfig, libudev, libusb, srcs, ... }:
let inherit (srcs) wii-u-gc-adapter; in
stdenv.mkDerivation {
  pname = "wii-u-gc-adapter";
  inherit (wii-u-gc-adapter) version;

  buildInputs = [ pkgconfig libudev libusb ];

  src = wii-u-gc-adapter;

  installPhase = ''
    mkdir -p $out/bin
    install wii-u-gc-adapter $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    platforms = platforms.linux;
    inherit version;
  };
}
