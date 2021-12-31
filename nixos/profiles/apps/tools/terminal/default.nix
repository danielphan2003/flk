{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.gitAndTools) hub;
    inherit (pkgs)
      bat
      exa
      du-dust
      duf
      fzf
      ghq
      gst
      procs
      ripgrep
      sd
      skim
      zsh-completions
      ;
  };
}
