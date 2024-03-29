{
  lib,
  stdenv,
  fog,
}:
stdenv.mkDerivation {
  inherit (fog.rainfox) pname src version;

  installPhase = ''
    mkdir -p $out/chrome
    cp -r ./ $out/chrome
  '';

  meta = with lib; {
    description = "It's like Photon, but better.";
    homepage = "https://github.com/1280px/rainfox";
    license = licenses.mit;
    maintainers = [maintainers.danielphan2003];
    platforms = platforms.all;
  };
}
