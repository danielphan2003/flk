{ luaPackages, srcs, lib, fetchurl, ... }:
let src = srcs.awestore;
in
luaPackages.buildLuarocksPackage rec {
  lua = luaPackages.lua;

  inherit src;
  inherit (src) version;

  pname = "awestore";

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
    maintainers = with maintainers; [ danielphan2003 ];
    license.fullName = "MIT/X11";
  };
}
