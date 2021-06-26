{ stdenv, lib, sources, meson, ninja }:
stdenv.mkDerivation rec {
  inherit (sources.libinih) pname src version;

  buildInputs = [ meson ninja ];

  mesonFlags = ''
    -Ddefault_library=shared
    -Ddistro_install=true
  '';

  meta = with lib; {
    description = "Simple .INI file parser in C";
    homepage = "https://github.com/benhoyt/inih";
    maintainers = [ danielphan2003 ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
