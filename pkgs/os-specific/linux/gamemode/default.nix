{ stdenv
, lib
, srcs
, meson
, ninja
, polkit
, pkgconfig
, systemd
, dbus
, libinih
, ...
}:
let inherit (srcs) gamemode; in
stdenv.mkDerivation {
  pname = "gamemode";

  inherit (gamemode) version;

  src = gamemode;

  prePatch = ''
    substituteInPlace daemon/gamemode-tests.c --replace "/usr/bin/gamemoderun" $out/bin/gamemoderun
    substituteInPlace daemon/gamemode-gpu.c --replace "/usr/bin/pkexec" ${polkit}/bin/pkexec
    substituteInPlace daemon/gamemode-context.c --replace "/usr/bin/pkexec" ${polkit}/bin/pkexec
    substituteInPlace lib/gamemode_client.h --replace 'dlopen("' 'dlopen("${
      placeholder "out"
    }/lib/'
  '';

  buildInputs = [ meson ninja pkgconfig systemd dbus libinih ];

  mesonFlags = ''
    -Dwith-util=false
    -Dwith-examples=false
    -Dwith-systemd-user-unit-dir=${placeholder "out"}/lib/systemd/user
  '';

  meta = with lib; {
    description = "Optimise Linux system performance on demand";
    homepage = "https://github.com/FeralInteractive/gamemode";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd3;
    platforms = platforms.linux;
    broken = true;
    inherit version;
  };
}
