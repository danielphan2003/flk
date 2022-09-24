{
  stdenv,
  lib,
  fog,
}:
stdenv.mkDerivation {
  pname = "ttf-segue";

  inherit (fog.segue-ui-linux) src version;

  installPhase = ''
    mkdir -p "$out/share/fonts/Microsoft/TrueType/Segoe UI"
    cp -r $src/font/* "$out/share/fonts/Microsoft/TrueType/Segoe UI"
  '';

  meta = with lib; {
    description = "Install segoe-ui font on linux";
    homepage = "https://github.com/mrbvrz/segoe-ui-linux";
    maintainers = [maintainers.danielphan2003];
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
