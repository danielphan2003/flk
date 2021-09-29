{ lib, newScope }:

lib.makeScope newScope (self: with self; {

  libxcvt = callPackage
    ({ stdenv, pkg-config, sources, meson, ninja }: stdenv.mkDerivation {
      inherit (sources.xorg-libxcvt) pname src version;
      builder = ./builder.sh;
      hardeningDisable = [ "bindnow" "relro" ];
      nativeBuildInputs = [ pkg-config meson ninja ];
      meta.platforms = lib.platforms.unix;
    })
    { };

})
