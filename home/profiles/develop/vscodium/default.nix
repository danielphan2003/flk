{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      roscop.activefileinstatusbar
      astro-build.astro-vscode
      nash.awesome-flutter-snippets
      formulahendry.code-runner
      github.vscode-codeql
      adpyke.codesnap
      ms-vscode.cpptools
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
    userSettings = import ./userSettings.nix pkgs;
    keybindings = import ./keybindings.nix;
  };
}
