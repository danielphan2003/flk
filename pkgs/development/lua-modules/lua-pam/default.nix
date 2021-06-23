{ stdenv, srcs, lib, lua, linux-pam, ... }:
let src = srcs.lua-pam;
in
stdenv.mkDerivation rec {
  inherit src;
  inherit (src) version;

  pname = "lua-pam";

  nativeBuildInputs = [ lua linux-pam ];

  installPhase = ''
    mkdir -p $out/lib
    install -Dm 755 liblua_pam.so -t "$out/lib"
  '';

  meta = with lib; {
    description = "A module for lua to use PAM. ";
    homepage = "https://github.com/rmtt/lua-pam";
    license.fullName = "MIT/X11";
    maintainers = with maintainers; [ danielphan2003 ];
    platforms = platforms.unix;
  };
}
