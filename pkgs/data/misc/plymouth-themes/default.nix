{ lib, stdenv, sources, theme ? "*" }:
stdenv.mkDerivation {
  inherit (sources.plymouth-themes) pname version src;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    cp -r pack_**/${theme} $out/share/plymouth/themes
    sed "s@\/usr\/@$out\/@" $out/share/plymouth/themes/*${theme}/${theme}.plymouth
  '';

  meta = with lib; {
    description = "A huge collection (80+) of plymouth themes ported from android bootanimations";
    homepage = "https://github.com/adi1090x/plymouth-themes";
    license = licenses.gpl3;
    maintainers = [ danielphan2003 ];
    platforms = platforms.linux;
  };
}