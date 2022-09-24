{
  stdenv,
  lib,
  fog,
  lua,
  linux-pam,
  ...
}:
stdenv.mkDerivation {
  inherit (fog.lua-pam) pname src version;

  nativeBuildInputs = [lua linux-pam];

  installPhase = ''
    mkdir -p $out/lib/lua-pam
    install -Dm 755 liblua_pam.so -t "$out/lib/lua-pam"
  '';

  meta = with lib; {
    description = "A module for lua to use PAM. ";
    homepage = "https://github.com/rmtt/lua-pam";
    license.fullName = "MIT/X11";
    maintainers = [maintainers.danielphan2003];
    platforms = platforms.unix;
  };
}
