{ stdenv, lib, sources }:
stdenv.mkDerivation rec {
  inherit (sources.sddm-chili) pname src version;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/chili
    cp -r * $out/share/sddm/themes/chili
  '';

  meta = with lib; {
    description = "The hottest theme around for SDDM";
    homepage = "https://github.com/MarianArlt/sddm-chili";
    maintainers = [ danielphan2003 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
