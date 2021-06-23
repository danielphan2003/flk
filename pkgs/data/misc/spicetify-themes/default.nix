{ lib, stdenv, srcs }:
let inherit (srcs) spicetify-themes; in
stdenv.mkDerivation rec {
  pname = "spicetify-themes";

  inherit (spicetify-themes) version;
  src = spicetify-themes;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    cp -r ./ $out
  '';

  meta = with lib; {
    description = "A community-driven collection of themes for Spicetify (https://github.com/khanhas/spicetify-cli)";
    homepage = "https://github.com/morpheusthewhite/spicetify-themes";
    license = licenses.mit;
    maintainers = with maintainers; [ danielphan2003 ];
    platforms = platforms.all;
  };
}
