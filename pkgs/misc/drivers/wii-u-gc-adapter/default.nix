{ stdenv, lib, sources, pkgconfig, libudev, libusb }:
stdenv.mkDerivation rec {
  inherit (sources.wii-u-gc-adapter) pname src version;

  buildInputs = [ pkgconfig libudev libusb ];

  installPhase = ''
    mkdir -p $out/bin
    install wii-u-gc-adapter $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
    maintainers = [ danielphan2003 ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
