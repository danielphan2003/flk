{ stdenv, lib, substituteAll, sources }:
stdenv.mkDerivation rec {
  inherit (sources.arkenfox-userjs) pname src version;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/user-js/profiles
    cp user.js $out/share/user-js/profiles
  '';

  meta = with lib; {
    description = "Firefox privacy, security and anti-fingerprinting";
    homepage = "https://github.com/arkenfox/user.js";
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
