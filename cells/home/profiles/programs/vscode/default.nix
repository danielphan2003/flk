{
  lib,
  pkgs,
  ...
}: {
  imports = lib.flk.getNixFiles ./.;

  programs.vscode = {
    enable = true;

    package = lib.mkDefault pkgs.vscode;

    mutableExtensionsDir = false;

    keybindings = [
      {
        key = "alt+f9";
        command = "workbench.action.tasks.build";
      }
      {
        key = "ctrl+shift+b";
        command = "workbench.action.tasks.build";
      }
      {
        key = "ctrl+alt+\\";
        command = "editor.action.goToTypeDefinition";
      }
      {
        key = "ctrl+alt+c";
        command = "workbench.action.terminal.openNativeConsole";
        when = "!terminalFocus";
      }
      {
        key = "ctrl+shift+c";
        command = "-workbench.action.terminal.openNativeConsole";
        when = "!terminalFocus";
      }
    ];

    extensions = with pkgs.vscode-extensions; [
      roscop.activefileinstatusbar
      astro-build.astro-vscode
      nash.awesome-flutter-snippets
      formulahendry.code-runner
      github.vscode-codeql
      adpyke.codesnap
      # ms-vscode.cpptools
      dzhavat.css-initial-value
      dart-code.dart-code
      icrawl.discord-vscode
      mikestead.dotenv
      dbaeumer.vscode-eslint
      tamasfe.even-better-toml
      dart-code.flutter
      eamodio.gitlens
      zignd.html-css-class-completion
      mathiasfrohlich.kotlin
      vadimcn.vscode-lldb
      yzhang.markdown-all-in-one
      shd101wyy.markdown-preview-enhanced
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      b4dm4n.nixpkgs-fmt
      ibm.output-colorizer
      alefragnani.pascal
      alefragnani.pascal-formatter
      esbenp.prettier-vscode
      jeroen-meijer.pubspec-assist
      ms-python.python
      msjsdiag.vscode-react-native
      humao.rest-client
      matklad.rust-analyzer-nightly
      svelte.svelte-vscode
      bradlc.vscode-tailwindcss
      pflannery.vscode-versionlens
    ];
  };
}
