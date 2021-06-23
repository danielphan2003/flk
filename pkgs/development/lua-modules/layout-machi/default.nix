{ luaPackages, srcs, lib, ... }:
let src = srcs.layout-machi;
in
luaPackages.buildLuarocksPackage rec {
  lua = luaPackages.lua;

  inherit src;
  inherit (src) version;

  pname = "layout-machi";
  disabled = (luaPackages.luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  dontUnpack = true;
  dontBuild = true;

  buildPhase = ":";

  installPhase = ''
    mkdir -p "$out/share/lua/${lua.luaversion}/layout-machi"
    cp -r $src/* "$out/share/lua/${lua.luaversion}/layout-machi"
  '';

  meta = with lib; {
    homepage = "https://github.com/xinhaoyuan/layout-machi";
    description = "AwesomeWM manual layout with an interactive editor";
    maintainers = with maintainers; [ danielphan2003 ];
    license.fullName = "MIT/X11";
  };
}
