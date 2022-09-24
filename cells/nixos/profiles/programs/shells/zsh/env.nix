{pkgs, ...}: {
  environment.sessionVariables = let
    fd = "${pkgs.fd}/bin/fd -H";
  in {
    SKIM_ALT_C_COMMAND =
      (pkgs.writeScript "cdr-skim.zsh" ''
        #!${pkgs.zsh}/bin/zsh
        source ${./cdr/cdr-skim.zsh}
      '')
      .outPath;

    SKIM_DEFAULT_COMMAND = fd;

    SKIM_CTRL_T_COMMAND = fd;

    ZDOTDIR = "~/.config/zsh";
  };
}
