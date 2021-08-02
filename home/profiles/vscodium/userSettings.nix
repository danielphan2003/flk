{ pkgs, ... }: {
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
      "args" = [ "-NoLogo" ];
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
  "terminal.external.linuxExec" = "${pkgs.alacritty}/bin/alacritty";
  "workbench.startupEditor" = "newUntitledFile";
  "editor.quickSuggestions" = {
    "strings" = true;
  };
  "css.validate" = false;
  "tailwindCSS.includeLanguages" = {
    "astro" = "html";
  };
}
