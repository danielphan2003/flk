{ pkgs, lib, ... }:
let inherit (builtins) attrValues; in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      matklad.rust-analyzer-nightly
      # ms-vscode.cpptools

      ActiveFileInStatusBar
      astro
      awesome-flutter-snippets
      bracket-pair-colorizer-2
      codeql
      codesnap
      # cpp
      css-initial-value
      dart-code
      dendron
      discord-presence
      dotenv
      eslint
      even-better-toml
      flutter
      gitlens
      html-css-class-completion
      Kotlin
      Material-theme
      markdown-all-in-one
      markdown-preview-enhanced
      material-icon-theme
      nix-env-selector
      output-colorizer
      nixpkgs-fmt
      pascal
      pascal-formatter
      prettier
      pubspec-assist
      python
      react-native
      rest-client
      # rusts
      svelte
      tailwindcss
      versionlens
    ]
    ++
    (if (builtins.elem pkgs.system pkgs.vscodium.meta.platforms)
      && (pkgs.system != "aarch64-linux")
    then
      [
        ms-python.python
      ]
    else
      [ ]);
    userSettings = import ./userSettings.nix { inherit pkgs; };
    keybindings = import ./keybindings.nix;
  };
}
