{ lib, stdenv, sources }:
stdenv.mkDerivation rec {
  inherit (sources.flyingfox) pname src version;

  installPhase = ''
    cp -r ./ $out
  '';

  patches = [ ./no-tabline.patch ];

  meta = with lib; {
    description = "An opinionated set of configurations for firefox";
    homepage = "https://flyingfox.netlify.app";
    license = licenses.mit;
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
  };
}
