{
  lib,
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.programs.shells.env] ++ lib.flk.getNixFiles ./.;

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = [pkgs.zsh-completions];

  environment.shellAliases.rz = "exec zsh";

  programs.zsh = {
    enable = true;

    enableGlobalCompInit = false;

    histSize = 10000;

    histFile = "~/.cache/zsh/history";

    setOptions = [
      "extendedglob"
      "incappendhistory"
      "sharehistory"
      "histignoredups"
      "histfcntllock"
      "histreduceblanks"
      "histignorespace"
      "histallowclobber"
      "autocd"
      "cdablevars"
      "nomultios"
      "pushdignoredups"
      "autocontinue"
      "promptsubst"
      "globdots"
    ];
  };
}
