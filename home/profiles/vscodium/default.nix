{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      # matklad.rust-analyzer
      ms-python.python
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
      rust
      svelte
      tailwindcss
      versionlens
    ];
    userSettings = import ./userSettings.nix { inherit pkgs; };
    keybindings = import ./keybindings.nix;
  };
}
