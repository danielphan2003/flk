{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.gitAndTools) hub;
    inherit (pkgs)
      bat
      exa
      du-dust
      duf
      fzf
      procs
      ripgrep
      skim
      zsh-completions
      ;
  };
}