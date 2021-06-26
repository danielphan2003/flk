{ stdenv, lib, sources
, dbus, glib, gtk3, gobject-introspection
, gtk-layer-shell, vala, makeWrapper
, pkg-config, meson, ninja
, light, pulseaudio, procps, gnugrep
, coreutils, gawk, gnused
}:
stdenv.mkDerivation rec {
  inherit (sources.avizo) pname src version;

  installFlags = [ "PREFIX=\${out}" "VERSION=${version}" ];

  nativeBuildInputs = [ pkg-config meson ninja makeWrapper ];

  buildInputs = [
    dbus glib gtk3 gobject-introspection
    gtk-layer-shell vala
  ];

  preFixup = ''
    wrapProgram $out/bin/volumectl --prefix PATH : ${lib.makeBinPath [ pulseaudio gnugrep gawk gnused coreutils gawk ]}
    wrapProgram $out/bin/lightctl --prefix PATH : ${lib.makeBinPath [ light procps gnugrep coreutils gawk ]}
  '';

  meta = with lib; {
    description = "A neat notification daemon";
    homepage = "https://github.com/misterdanb/avizo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ danielphan2003 ];
  };
}
