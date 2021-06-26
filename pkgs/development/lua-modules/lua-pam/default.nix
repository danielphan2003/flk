{ stdenv, lib, sources, lua, linux-pam, ... }:
stdenv.mkDerivation rec {
  inherit (sources.lua-pam) pname src version;

  nativeBuildInputs = [ lua linux-pam ];

  installPhase = ''
    mkdir -p $out/lib
    install -Dm 755 liblua_pam.so -t "$out/lib"
  '';

  meta = with lib; {
    description = "A module for lua to use PAM. ";
    homepage = "https://github.com/rmtt/lua-pam";
    license.fullName = "MIT/X11";
    maintainers = [ danielphan2003 ];
    platforms = platforms.unix;
  };
}
