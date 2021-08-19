{ stdenv
, lib
, cmake
, sources
}:

let
  cmakePath =
    if stdenv.isi686 then
      "mingw-x86.cmake"
    else if stdenv.isx86_64 then
      "mingw-amd64.cmake"
    else
      throw "Unsupported architecture";
in

stdenv.mkDerivation {
  inherit (sources) pname src version;

  outputs = [ "out" "fd" ];

  buildInputs = [ cmake ];

  buildFlags = [ "-DCMAKE_TOOLCHAIN_FILE=${cmakePath}" ];

  postFixup = ''
    # mkdir -vp $fd/FV
    # mv -v $out/FV/OVMF{,_CODE,_VARS}.fd $fd/FV
  '';

  meta = with lib; {
    description = "Quibble - the custom Windows bootloader";
    homepage = "https://github.com/maharmstone/quibble";
    license = licenses.gpl3;
    broken = true;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
