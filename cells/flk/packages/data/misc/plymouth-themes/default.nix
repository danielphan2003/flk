{
  lib,
  stdenv,
  fog,
  theme ? "angular",
}:
stdenv.mkDerivation {
  inherit (fog.plymouth-themes) version src;

  pname = "${fog.plymouth-themes.pname}-${theme}";

  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    cp -r pack_**/${theme} $out/share/plymouth/themes
    substituteInPlace $out/share/plymouth/themes/${theme}/${theme}.plymouth \
      --replace "/usr" "$out"
  '';

  meta = with lib; {
    description = "A huge collection (80+) of plymouth themes ported from android bootanimations";
    homepage = "https://github.com/adi1090x/plymouth-themes";
    license = licenses.gpl3;
    maintainers = [maintainers.danielphan2003];
    platforms = platforms.linux;
  };
}
