final: prev: {
  luaPackages = prev.luaPackages // {
    bling = prev.callPackage ../pkgs/development/lua-modules/bling { };

    layout-machi = prev.callPackage ../pkgs/development/lua-modules/layout-machi { };

    lua-pam = prev.callPackage ../pkgs/development/lua-modules/lua-pam { };

    awestore = prev.callPackage ../pkgs/development/lua-modules/awestore { };
  };
}
