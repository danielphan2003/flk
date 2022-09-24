{
  stdenv,
  lib,
  substituteAll,
  fog,
}:
stdenv.mkDerivation {
  inherit (fog.arkenfox-userjs) pname src version;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/firefox
    cp user.js $out/share/firefox
  '';

  meta = with lib; {
    description = "Firefox privacy, security and anti-fingerprinting";
    homepage = "https://github.com/arkenfox/user.js";
    maintainers = [maintainers.danielphan2003];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
