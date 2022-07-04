{
  stdenv,
  lib,
  dan-nixpkgs,
  SDL,
  SDL_image,
  udev,
  libXext,
  libXxf86vm,
  libXdamage,
  libXcomposite,
  libXrender,
  pkgconfig,
  autoreconfHook,
  gnumake,
}:
stdenv.mkDerivation {
  inherit (dan-nixpkgs.steamcompmgr) pname src version;

  buildInputs = [
    SDL
    SDL_image
    udev
    libXext
    libXxf86vm
    libXdamage
    libXcomposite
    libXrender
    pkgconfig
    autoreconfHook
    gnumake
  ];

  meta = with lib; {
    description = "SteamOS Compositor";
    homepage = "https://github.com/ChimeraOS/steamos-compositor-plus";
    maintainers = [maintainers.danielphan2003];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
