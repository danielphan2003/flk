{
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.programs.vscode];
  programs.vscode.package = pkgs.vscodium;
}
