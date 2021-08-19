{ appimageTools, lib, sources, makeDesktopItem, gsettings-desktop-schemas, gtk3 }:
let
  inherit (sources.leonflix) pname src version;

  name = "${pname}-${version}";

  desktopItem = makeDesktopItem {
    name = "Leonflix";
    exec = pname;
    icon = pname;
    comment = "free media thing";
    desktopName = "Leonflix";
    genericName = "Leonflix";
    categories = lib.concatMapStrings (x: x + ";")
      [ "AudioVideo" ];
  };
in
appimageTools.wrapType2 {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "free media thing";
    homepage = https://www.leonflix.net;
    license = licenses.asl20;
    # Should be cross-platform, but for now we just grab the appimage
    platforms = [ "x86_64-linux" ];
    maintainers = [ danielphan2003 ];
  };
}
