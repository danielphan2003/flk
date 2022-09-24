final: prev: {
  fx_cast_bridge = prev.fx_cast_bridge.overrideAttrs (_: let
    nodeEnv = import ../pkgs/tools/misc/fx_cast/node-env.nix {
      inherit (final.pkgs) nodejs stdenv lib python2 runCommand writeTextFile writeShellScript;
      inherit (final) pkgs;

      libtool =
        if final.stdenv.isDarwin
        then final.pkgs.darwin.cctools
        else null;
    };

    nodePackages = import ../pkgs/tools/misc/fx_cast/node-packages.nix {
      inherit (final.pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
      inherit nodeEnv;

      globalBuildInputs = [final.avahi-compat];
    };
  in {
    inherit (final.fog.fx_cast) src version;

    buildPhase = ''
      ln -vs ${nodePackages.nodeDependencies}/lib/node_modules app/node_modules
      # The temporary home solves the "failed with exit code 243"
      HOME="$(mktemp -d)" npm run build:app
    '';

    postInstall = ''
      rm $out/bin/fx_cast_bridge
      echo "#! /bin/sh
        NODE_PATH=${nodePackages.nodeDependencies}/lib/node_modules exec ${final.nodejs}/bin/node $out/opt/fx_cast_bridge/src/main.js --_name fx_cast_bridge \"\$@\"
      " >$out/bin/fx_cast_bridge
      chmod +x $out/bin/fx_cast_bridge
    '';
  });
}
