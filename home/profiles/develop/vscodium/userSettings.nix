{
  alacritty,
  nodejs,
  jre_minimal,
  gcc,
  python,
  ruby,
  go,
  lua,
  bash,
  rustc,
  ...
} @ pkgs: {
  "workbench.iconTheme" = "material-icon-theme";
  "gitlens.defaultDateFormat" = "H:mm:ss dd.MM.yy";
  "gitlens.hovers.currentLine.over" = "line";
  "gitlens.statusBar.alignment" = "left";
  "editor.fontSize" = 16;
  "editor.tabSize" = 2;
  "git.autofetch" = true;
  "files.exclude" = {
    "**/.classpath" = true;
    "**/.factorypath" = true;
    "**/.project" = true;
    "**/.settings" = true;
    "**/*.exe" = true;
    "**/*.o" = true;
  };
  "breadcrumbs.enabled" = true;
  "editor.fontFamily" = "Iosevka Nerd Font, Consolas, monospace";
  "debug.console.fontFamily" = "Iosevka Term";
  "debug.console.fontSize" = 16;
  "terminal.integrated.fontFamily" = "Iosevka Term";
  "terminal.integrated.fontSize" = 18;
  "editor.suggestSelection" = "first";
  "[javascript]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };
  "javascript.validate.enable" = false;
  "dart.flutterCreateAndroidLanguage" = "kotlin";
  "dart.flutterCreateIOSLanguage" = "swift";
  "dart.previewFlutterUiGuides" = true;
  "editor.fontLigatures" = true;
  "terminal.integrated.profiles.windows" = {
    "PowerShell" = {
      "source" = "PowerShell";
      "icon" = "terminal-powershell";
      "args" = ["-NoLogo"];
    };
  };
  "terminal.integrated.experimentalUseTitleEvent" = true;
  "files.autoSave" = "onWindowChange";
  "workbench.sideBar.location" = "right";
  "python.insidersChannel" = "off";
  "pascal.format.indent" = 4;
  "pascal.formatter.engine" = "ptop";
  "snapcode.transparentBackground" = true;
  "dart.previewFlutterUiGuidesCustomTracking" = true;
  "dart.warnWhenEditingFilesOutsideWorkspace" = false;
  "editor.tabCompletion" = "onlySnippets";
  "nix.enableLanguageServer" = true;
  "oneDarkPro.editorTheme" = "oneDarkPro";
  "oneDarkPro.vivid" = true;
  "oneDarkPro.bold" = true;
  "workbench.colorTheme" = "One Dark Pro";
  "workbench.editor.wrapTabs" = true;
  "workbench.editor.tabSizing" = "fit";
  "workbench.editor.decorations.colors" = true;
  "workbench.editor.decorations.badges" = true;
  "workbench.editor.enablePreviewFromCodeNavigation" = true;
  "window.menuBarVisibility" = "toggle";
  "[nix]" = {
    "editor.defaultFormatter" = "jnoortheen.nix-ide";
  };
  "[rust]" = {
    "editor.defaultFormatter" = "matklad.rust-analyzer";
  };
  "update.mode" = "none";
  "dart.previewLsp" = true;
  "terminal.external.linuxExec" = "${alacritty}/bin/alacritty";
  "workbench.startupEditor" = "newUntitledFile";
  "editor.quickSuggestions" = {
    "strings" = true;
  };
  "css.validate" = false;
  "tailwindCSS.includeLanguages" = {
    "astro" = "html";
  };
  "workbench.editor.untitled.experimentalLanguageDetection" = true;
  "discord.workspaceExcludePatterns" = ["nixpkgs"];
  "code-runner.runInTerminal" = true;
  "code-runner.executorMap" = {
    "javascript" = "${nodejs}/bin/node";
    "java" = "cd $dir && ${jre_minimal}/bin/javac $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && ${jre_minimal}/bin/java $fileNameWithoutExt.o";
    "c" = "cd $dir && ${gcc}/bin/gcc $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    "cpp" = "cd $dir && ${gcc}/bin/g++ $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "objective-c" = "cd $dir && gcc -framework Cocoa $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "php" = "${php}/bin/php";
    "python" = "${python}/bin/python -u";
    # "perl" = "${perl}/bin/perl";
    # "perl6" = "perl6";
    "ruby" = "${ruby}/bin/ruby";
    "go" = "${go}/bin/go run";
    "lua" = "${lua}/bin/lua";
    # "groovy" = "${groovy}/bin/groovy";
    # "powershell" = "${powershell}/bin/powershell -ExecutionPolicy ByPass -File";
    # "bat" = "cmd /c";
    "shellscript" = "${bash}/bin/bash";
    # "fsharp" = "${fsharp}/bin/fsi";
    # "csharp" = "scriptcs";
    # "vbscript" = "cscript //Nologo";
    # "typescript" = "${nodePackages.typescript}/bin/ts-node";
    # "coffeescript" = "coffee";
    # "scala" = "${scala}/bin/scala";
    # "swift" = "${swift}/bin/swift";
    # "julia" = "${julia}/bin/julia";
    # "crystal" = "${crystal}/bin/crystal";
    # "ocaml" = "${ocaml}/bin/ocaml";
    # "r" = "${rWrapper}/bin/Rscript";
    # "applescript" = "osascript";
    # "clojure" = "${clojure}/bin/lein exec";
    # "haxe" = "${haxe}/bin/haxe --cwd $dirWithoutTrailingSlash --run $fileNameWithoutExt";
    "rust" = "cd $dir && ${rustc}/bin/rustc $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "racket" = "${racket}/bin/racket";
    # "scheme" = "${scheme48}/bin/csi -script";
    # "ahk" = "autohotkey";
    # "autoit" = "autoit3";
    # "dart" = "${dart}/bin/dart";
    # "pascal" = "cd $dir && ${fpc}/bin/fpc $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "d" = "cd $dir && dmd $fileName && mv $fileNameWithoutExt $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "haskell" = "${haskell}/bin/runhaskell";
    # "nim" = "${nim}/bin/nim compile --verbosity:0 --hints:off --run";
    # "lisp" = "${lisp}/bin/sbcl --script";
    "kit" = "kitc --run";
    # "v" = "${vlang}/bin/v run";
    # "sass" = "${sass}/bin/sass --style expanded";
    # "scss" = "${sass}/bin/scss --style expanded";
    # "less" = "cd $dir && ${lessc}/bin/lessc $fileName $fileNameWithoutExt.css";
    # "FortranFreeForm" = "cd $dir && gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "fortran-modern" = "cd $dir && ${gfortran}/bin/gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "fortran_fixed-form" = "cd $dir && gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
    # "fortran" = "cd $dir && ${gfortran}/bin/gfortran $fileName -o $fileNameWithoutExt.o && $dir$fileNameWithoutExt.o";
  };
  "editor.guides.bracketPairs" = true;
}
