{ luaPackages, srcs, lib, ... }:
let src = srcs.bling;
in
luaPackages.buildLuarocksPackage rec {
  lua = luaPackages.lua;

  inherit src;
  inherit (src) version;

  pname = "bling";
  disabled = (luaPackages.luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  dontUnpack = true;
  dontBuild = true;

  buildPhase = ":";

  installPhase = ''
    mkdir -p "$out/share/lua/${lua.luaversion}/bling"
    cp -r $src/* "$out/share/lua/${lua.luaversion}/bling"
  '';

  meta = with lib; {
    homepage = "https://github.com/BlingCorp/bling";
    description = "Utilities for the awesome window manager";
    maintainers = with maintainers; [ danielphan2003 ];
    license.fullName = "MIT/X11";
  };
}
