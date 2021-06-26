{ stdenv, lib, sources
, SDL, SDL_image
, libudev, libXext, libXxf86vm
, libXdamage, libXcomposite, libXrender
, pkgconfig, autoreconfHook, gnumake
}:
stdenv.mkDerivation rec {
  inherit (sources.steamcompmgr) pname src version;

  buildInputs = [
    SDL SDL_image
    libudev libXext libXxf86vm
    libXdamage libXcomposite libXrender
    pkgconfig autoreconfHook gnumake
  ];

  meta = with lib; {
    description = "SteamOS Compositor";
    homepage = "https://github.com/ChimeraOS/steamos-compositor-plus";
    maintainers = [ danielphan2003 ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
