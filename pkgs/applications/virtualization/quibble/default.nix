{
  stdenv,
  lib,
  cmake,
  mingwGccs,
  sources,
}: let
  inherit (sources.quibble) pname src version;
  cmakePath =
    if stdenv.isi686
    then "mingw-x86.cmake"
    else if stdenv.isx86_64
    then "mingw-amd64.cmake"
    else throw "Unsupported architecture";
in
  stdenv.mkDerivation {
    inherit pname src version;

    nativeBuildInputs = [cmake] ++ mingwGccs;

    PROJECT_VERSION = version;

    buildPhase = ''
      mkdir -p $out/share/quibble/{amd64,x86} build
      cd build
      cmake -DCMAKE_TOOLCHAIN_FILE=$src/${cmakePath} -DPROJECT_VERSION=${version} $src
      make
    '';

    installPhase = ''
      ls -la
      ls -la build/*
      mv build/quibble.efi
      exit 1
    '';

    meta = with lib; {
      description = "Quibble - the custom Windows bootloader";
      homepage = "https://github.com/maharmstone/quibble";
      license = licenses.gpl3;
      broken = true;
      platforms = ["x86_64-linux" "i686-linux"];
    };
  }
