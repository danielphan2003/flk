{
  lib,
  mkYarnPackage,
  fog,
}: let
  inherit (fog.dribbblish-dynamic-theme) pname src version;
in
  mkYarnPackage {
    inherit pname src version;

    COMMIT_HASH = lib.substring 0 7 version;

    yarnLock = ./yarn.lock;

    buildPhase = ''
      yarn --offline build
    '';

    distPhase = "true";

    configurePhase = "ln -s $node_modules node_modules";

    installPhase = ''
      mkdir -p $out/theme $out/extensions
      cp -r dist/* $out/theme
      rm $out/theme/dribbblish-dynamic.js
      cp {dist,$out/extensions}/dribbblish-dynamic.js
    '';

    meta = with lib; {
      description = "A mod of Dribbblish theme for Spicetify with support for light/dark modes and album art based colors.";
      homepage = "https://github.com/JulienMaille/dribbblish-dynamic-theme";
      maintainers = [maintainers.danielphan2003];
      platforms = platforms.all;
    };
  }
