{ lib, stdenv, srcs }:
let inherit (srcs) flyingfox; in
stdenv.mkDerivation rec {
  pname = "flyingfox";

  inherit (flyingfox) version;
  src = flyingfox;

  installPhase = ''
    cp -r ./ $out
  '';

  patches = [ ./no-tabline.patch ];

  meta = with lib; {
    description = "An opinionated set of configurations for firefox";
    homepage = "https://flyingfox.netlify.app";
    license = licenses.mit;
    maintainers = with maintainers; [ danielphan2003 ];
    platforms = platforms.all;
  };
}
