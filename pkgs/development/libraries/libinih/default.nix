{ stdenv, lib, meson, ninja, srcs, ... }:
let inherit (srcs) libinih; in
stdenv.mkDerivation {
  pname = "libinih";

  # version will resolve to 53, as specified in the final example below
  inherit (libinih) version;

  src = libinih;

  buildInputs = [ meson ninja ];

  mesonFlags = ''
    -Ddefault_library=shared
    -Ddistro_install=true
  '';

  meta = with lib; {
    description = "Simple .INI file parser in C";
    homepage = "https://github.com/benhoyt/inih";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd3;
    platforms = platforms.all;
    inherit version;
  };
}
