{ stdenv, lib, sources, patchelf, gcc, glib, nspr, nss, unzip }:
let mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}"; in
stdenv.mkDerivation rec {
  inherit (sources.widevine-cdm) pname src version;

  unpackCmd = "unzip -d ./src $curSrc";

  nativeBuildInputs = [ unzip ];

  PATCH_RPATH = mkrpath [ gcc.cc glib nspr nss ];

  patchPhase = ''
    patchelf --set-rpath "$PATCH_RPATH" libwidevinecdm.so
  '';

  installPhase = ''
    install -vD libwidevinecdm.so "$out/lib/libwidevinecdm.so"
  '';

  meta.platforms = [ "x86_64-linux" ];
}

