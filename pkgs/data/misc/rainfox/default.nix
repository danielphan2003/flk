{ lib, stdenv, srcs }:
let inherit (srcs) rainfox; in
stdenv.mkDerivation rec {
  pname = "rainfox";

  inherit (rainfox) version;
  src = rainfox;

  installPhase = ''
    mkdir -p $out/chrome
    cp -r ./ $out/chrome
  '';

  meta = with lib; {
    description = "It's like Photon, but better.";
    homepage = "https://github.com/1280px/rainfox";
    license = licenses.mit;
    maintainers = with maintainers; [ danielphan2003 ];
    platforms = platforms.all;
  };
}
