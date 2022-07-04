{
  stdenv,
  lib,
  dan-nixpkgs,
  meson,
  ninja,
}:
stdenv.mkDerivation {
  inherit (dan-nixpkgs.libinih) pname src version;

  buildInputs = [meson ninja];

  mesonFlags = ''
    -Ddefault_library=shared
    -Ddistro_install=true
  '';

  meta = with lib; {
    description = "Simple .INI file parser in C";
    homepage = "https://github.com/benhoyt/inih";
    maintainers = [maintainers.danielphan2003];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
