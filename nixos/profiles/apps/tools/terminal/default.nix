{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.gitAndTools) hub;
    inherit (pkgs)
      bat
      exa
      duf
      fzf
      procs
      ripgrep
      skim
      zsh-completions
      ;
  };
}