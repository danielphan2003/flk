{ stdenv, lib, substituteAll, srcs }:
let inherit (srcs) user-js; in
stdenv.mkDerivation rec {
  pname = "user-js";

  inherit (user-js) version;

  src = user-js;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/user-js/profiles
    cp user.js $out/share/user-js/profiles
  '';

  meta = with lib; {
    description = "Firefox privacy, security and anti-fingerprinting";
    homepage = "https://github.com/arkenfox/user.js";
    maintainers = [ maintainers.danielphan2003 ];
    platforms = platforms.all;
    license = licenses.mit;
    inherit version;
  };
}
