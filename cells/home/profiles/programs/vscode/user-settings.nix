{
  lib,
  pkgs,
  ...
}: {
  programs.vscode.userSettings = {
    "[javascript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };

    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };

    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };

    "breadcrumbs.enabled" = true;

    "css.validate" = false;

    "dart.flutterCreateAndroidLanguage" = "kotlin";
    "dart.flutterCreateIOSLanguage" = "swift";
    "dart.previewFlutterUiGuides" = true;
    "dart.previewFlutterUiGuidesCustomTracking" = true;
    "dart.previewLsp" = true;
    "dart.warnWhenEditingFilesOutsideWorkspace" = false;

    "debug.console.fontFamily" = "Iosevka Term";
    "debug.console.fontSize" = 16;

    "discord.workspaceExcludePatterns" = ["NixOS/nixpkgs"];

    "editor.experimental.stickyScroll.enabled" = true;
    "editor.fontFamily" = "Iosevka Nerd Font, Consolas, monospace";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 16;
    "editor.guides.bracketPairs" = true;
    "editor.quickSuggestions" = {
      "strings" = true;
    };
    "editor.suggestSelection" = "first";
    "editor.tabCompletion" = "onlySnippets";
    "editor.tabSize" = 2;

    "files.associations" = {
      "*.yuck" = "clojure";
    };
    "files.autoSave" = "onWindowChange";
    "files.exclude" = {
      "**/.classpath" = true;
      "**/.factorypath" = true;
      "**/.project" = true;
      "**/.settings" = true;
      "**/*.exe" = true;
      "**/*.o" = true;
    };

    "git.autofetch" = true;

    "gitlens.defaultDateFormat" = "H:mm:ss dd.MM.yy";
    "gitlens.hovers.currentLine.over" = "line";
    "gitlens.statusBar.alignment" = "left";

    "javascript.validate.enable" = false;

    "nix.enableLanguageServer" = true;

    "oneDarkPro.bold" = true;
    "oneDarkPro.editorTheme" = "One Dark Pro";
    "oneDarkPro.vivid" = true;

    "pascal.format.indent" = 4;
    "pascal.formatter.engine" = "ptop";
    "python.insidersChannel" = "off";

    "snapcode.transparentBackground" = true;

    "tailwindCSS.includeLanguages" = {
      "astro" = "html";
    };

    "terminal.external.linuxExec" = "${pkgs.alacritty}/bin/alacritty";
    "terminal.integrated.experimentalUseTitleEvent" = true;
    "terminal.integrated.fontFamily" = "Iosevka Term";
    "terminal.integrated.fontSize" = 18;
    "terminal.integrated.profiles.windows" = {
      "PowerShell" = {
        "source" = "PowerShell";
        "icon" = "terminal-powershell";
        "args" = ["-NoLogo"];
      };
    };
    "terminal.integrated.scrollback" = 10000;
    "terminal.integrated.shellIntegration.enabled" = false;

    "update.mode" = "none";

    "window.menuBarVisibility" = "toggle";

    "workbench.colorTheme" = "One Dark Pro";
    "workbench.editor.decorations.badges" = true;
    "workbench.editor.decorations.colors" = true;
    "workbench.editor.enablePreviewFromCodeNavigation" = true;
    "workbench.editor.tabSizing" = "fit";
    "workbench.editor.untitled.experimentalLanguageDetection" = true;
    "workbench.editor.wrapTabs" = true;
    "workbench.sideBar.location" = "right";
    "workbench.startupEditor" = "newUntitledFile";
    "workbench.iconTheme" = "material-icon-theme";

    "code-runner.runInTerminal" = true;
    "code-runner.executorMap" = {
      "javascript" = "${pkgs.nodejs}/bin/node";
      "java" = "cd $dir && ${pkgs.jre_minimal}/bin/javac $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && ${pkgs.jre_minimal}/bin/java $fileNameWithoutExt.o";
      "c" = "cd $dir && ${pkgs.gcc}/bin/gcc $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      "cpp" = "cd $dir && ${pkgs.gcc}/bin/g++ $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "objective-c" = "cd $dir && gcc -framework Cocoa $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "php" = "${pkgs.php}/bin/php";
      "python" = "${pkgs.python}/bin/python -u";
      # "perl" = "${pkgs.perl}/bin/perl";
      # "perl6" = "perl6";
      "ruby" = "${pkgs.ruby}/bin/ruby";
      "go" = "${pkgs.go}/bin/go run";
      "lua" = "${pkgs.lua}/bin/lua";
      # "groovy" = "${pkgs.groovy}/bin/groovy";
      # "powershell" = "${pkgs.powershell}/bin/powershell -ExecutionPolicy ByPass -File";
      # "bat" = "cmd /c";
      "shellscript" = "${pkgs.bash}/bin/bash";
      # "fsharp" = "${pkgs.fsharp}/bin/fsi";
      # "csharp" = "scriptcs";
      # "vbscript" = "cscript //Nologo";
      # "typescript" = "${pkgs.nodePackages.typescript}/bin/ts-node";
      # "coffeescript" = "coffee";
      # "scala" = "${pkgs.scala}/bin/scala";
      # "swift" = "${pkgs.swift}/bin/swift";
      # "julia" = "${pkgs.julia}/bin/julia";
      # "crystal" = "${pkgs.crystal}/bin/crystal";
      # "ocaml" = "${pkgs.ocaml}/bin/ocaml";
      # "r" = "${pkgs.rWrapper}/bin/Rscript";
      # "applescript" = "osascript";
      # "clojure" = "${pkgs.clojure}/bin/lein exec";
      # "haxe" = "${pkgs.haxe}/bin/haxe --cwd $dirWithoutTrailingSlash --run $fileNameWithoutExt";
      "rust" = "cd $dir && ${pkgs.rustc}/bin/rustc $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "racket" = "${pkgs.racket}/bin/racket";
      # "scheme" = "${pkgs.scheme48}/bin/csi -script";
      # "ahk" = "autohotkey";
      # "autoit" = "autoit3";
      # "dart" = "${pkgs.dart}/bin/dart";
      # "pascal" = "cd $dir && ${pkgs.fpc}/bin/fpc $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "d" = "cd $dir && dmd $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "haskell" = "${pkgs.haskell}/bin/runhaskell";
      # "nim" = "${pkgs.nim}/bin/nim compile --verbosity:0 --hints:off --run";
      # "lisp" = "${pkgs.lisp}/bin/sbcl --script";
      "kit" = "kitc --run";
      # "v" = "${pkgs.vlang}/bin/v run";
      # "sass" = "${pkgs.sass}/bin/sass --style expanded";
      # "scss" = "${pkgs.sass}/bin/scss --style expanded";
      # "less" = "cd $dir && ${pkgs.lessc}/bin/lessc $fileName $fileNameWithoutExt.css";
      # "FortranFreeForm" = "cd $dir && gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "fortran-modern" = "cd $dir && ${pkgs.gfortran}/bin/gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "fortran_fixed-form" = "cd $dir && gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
      # "fortran" = "cd $dir && ${pkgs.gfortran}/bin/gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    };
  };
}
