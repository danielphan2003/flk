{ lib, srcs, stdenv, ... }:
let inherit (srcs) sddm-chili; in
stdenv.mkDerivation {
  pname = "sddm-chili";

  inherit (sddm-chili) version;

  src = sddm-chili;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/chili

    cp -r * $out/share/sddm/themes/chili
  '';

  meta = with lib; {
    inherit version;
    description = "The hottest theme around for SDDM";
    homepage = "https://github.com/MarianArlt/sddm-chili";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
