{
  stdenv,
  lib,
  substituteAll,
  dan-nixpkgs,
}:
stdenv.mkDerivation {
  inherit (dan-nixpkgs.arkenfox-userjs) pname src version;

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
