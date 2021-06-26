{ lib, sources, luaPackages }:
luaPackages.buildLuarocksPackage rec {
  lua = luaPackages.lua;

  inherit (sources.awestore) pname src version;

  disabled = (luaPackages.luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  dontUnpack = true;
  dontBuild = true;

  buildPhase = ":";

  installPhase = ''
    mkdir -p "$out/share/lua/${lua.luaversion}/awestore"
    cp -r $src/src/* "$out/share/lua/${lua.luaversion}/awestore"
  '';

  meta = with lib; {
    homepage = "https://github.com/K4rakara/awestore";
    description = "Sveltes store API for AwesomeWM";
    maintainers = [ danielphan2003 ];
    license.fullName = "MIT/X11";
  };
}
