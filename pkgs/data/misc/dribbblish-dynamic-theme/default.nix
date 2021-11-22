{ lib
, npmlock2nix
, sources
, stdenv

, nodejs
, python3
}:

let
  inherit (sources.dribbblish-dynamic-theme) pname version;
  packageJson = ./package.json;
  packageLockJson = ./package-lock.json;

  src = stdenv.mkDerivation {
    inherit pname version packageLockJson;
    inherit (sources.dribbblish-dynamic-theme) src;

    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out
      cp $packageLockJson $out/package-lock.json
    '';
  };

  node_modules = npmlock2nix.node_modules {
    inherit src packageJson packageLockJson;
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
  inherit pname src version node_modules packageJson packageLockJson;

  COMMIT_HASH = lib.substring 0 7 version;

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
