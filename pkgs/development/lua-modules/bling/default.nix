{ lib, sources, luaPackages }:
luaPackages.buildLuarocksPackage rec {
  lua = luaPackages.lua;

  inherit (sources.bling) pname src version;

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
    maintainers = [ danielphan2003 ];
    license.fullName = "MIT/X11";
  };
}
