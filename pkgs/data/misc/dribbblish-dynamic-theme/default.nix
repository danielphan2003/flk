{ lib
, npmlock2nix
, sources

, nodejs
, python3
, yarn
}:

let
  inherit (sources.dribbblish-dynamic-theme) pname src version;
  node_modules = npmlock2nix.internal.yarn.node_modules {
    inherit src;
    yarnLockFile = ./yarn.lock;
    buildInputs = [ python3 ];
    preBuild = ''
      mkdir -p .node-gyp/${nodejs.version}
      echo 9 > .node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include .node-gyp/${nodejs.version}
      export npm_config_nodedir=${nodejs}
    '';
  };
in

npmlock2nix.build {
  inherit pname src version node_modules;

  nativeBuildInputs = [ yarn ];

  buildCommands = [ "yarn run build" ];

  installPhase = ''
    mkdir -p $out/theme $out/extensions
    cp -r dist/* $out/theme
    rm $out/theme/dribbblish-dynamic.js
    cp {dist,$out/extensions}/dribbblish-dynamic.js
  '';

  meta = with lib; {
    description = "A mod of Dribbblish theme for Spicetify with support for light/dark modes and album art based colors.";
    homepage = "https://github.com/JulienMaille/dribbblish-dynamic-theme";
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
  };
}
