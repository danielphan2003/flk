{ stdenvNoCC, lib, srcs, externalStyle ? "$out/share/dynamic-wallpaper/images" }:
let inherit (srcs) dwall-improved; in
stdenvNoCC.mkDerivation rec {
  pname = "dwall-improved";

  inherit (dwall-improved) version;

  src = dwall-improved;

  postPatch = ''
    patchShebangs dwall.sh
    sed -i -e "s#/usr/share/dynamic-wallpaper/images#${externalStyle}#g" \
      -e "s#ls \$DIR#find \"\${externalStyle}\" -maxdepth 2 -mindepth 1 -type d | sed \"s\#\${externalStyle}/\#\#g\"#g" dwall.sh
    sed -i "s#\$out#$out#g" dwall.sh
  '';

  installPhase = ''
    mkdir -p $out/share/dynamic-wallpaper/images
    cp -r images/* $out/share/dynamic-wallpaper/images
    install -m755 -D dwall.sh $out/bin/dwall.sh
  '';

  meta = with lib; {
    description = "A bash script to adapt your wallpaper to the time ";
    homepage = "https://github.com/GitGangGuy/dynamic-wallpaper-improved";
    maintainers = with maintainers; [ danielphan2003 ];
    platforms = platforms.unix;
    license = licenses.gpl3;
    inherit (version);
  };

}
