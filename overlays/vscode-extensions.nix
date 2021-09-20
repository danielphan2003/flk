final: prev: {
  vscode-extensions = with prev; vscode-extensions // {
    ms-vscode-cpptools =
      let
        inherit (final.sources.vscode-extensions-ms-vscode-cpptools) src version;
        gdbUseFixed = true;

        gdbDefaultsTo = if gdbUseFixed then "${gdb}/bin/gdb" else "gdb";

        openDebugAD7Script = writeScript "OpenDebugAD7" ''
          #!${runtimeShell}
          BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"
          ${lib.optionalString gdbUseFixed ''
            export PATH=''${PATH}''${PATH:+:}${gdb}/bin
          ''}
          ${mono}/bin/mono $BIN_DIR/bin/OpenDebugAD7.exe $*
        '';
      in
      vscode-extensions.ms-vscode-cpptools.overrideAttrs (o: {
        inherit (vscode-extensions.ms-vscode.cpptools) meta;

        installPrefix = "share/vscode/extensions/ms-vscode.cpptools";

        name = "vscode-extension-ms-vscode-cpptools-${version}";

        buildInputs = o.buildInputs ++ [ jq ];

        postPatch = ''
          mv ./package.json ./package_orig.json

          # 1. Add activation events so that the extension is functional. This listing is empty when unpacking the extension but is filled at runtime.
          # 2. Patch `package.json` so that nix's *gdb* is used as default value for `miDebuggerPath`.
          cat ./package_orig.json | \
            jq --slurpfile actEvts ${../pkgs/misc/vscode-extensions/cpptools/package-activation-events.json} '(.activationEvents) = $actEvts[0]' | \
            jq '(.contributes.debuggers[].configurationAttributes | .attach , .launch | .properties.miDebuggerPath | select(. != null) | select(.default == "/usr/bin/gdb") | .default) = "${gdbDefaultsTo}"' > \
            ./package.json

          # Prevent download/install of extensions
          touch "./install.lock"

          # Mono runtimes from nix package (used by generated `OpenDebugAD7`).
          mv ./debugAdapters/bin/OpenDebugAD7 ./debugAdapters/bin/OpenDebugAD7_orig
          cp -p "${openDebugAD7Script}" "./debugAdapters/bin/OpenDebugAD7"

          # Clang-format from nix package.
          mv  ./LLVM/ ./LLVM_orig
          mkdir "./LLVM/"
          find "${clang-tools}" -mindepth 1 -maxdepth 1 | xargs ln -s -t "./LLVM"

          # Patching  cpptools and cpptools-srv
          elfInterpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
          patchelf --set-interpreter "$elfInterpreter" ./bin/cpptools
          patchelf --set-interpreter "$elfInterpreter" ./bin/cpptools-srv
          chmod a+x ./bin/cpptools{-srv,}
        '';
      });
  };
}
