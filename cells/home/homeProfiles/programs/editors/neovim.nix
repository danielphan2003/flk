{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    plugins = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        fennel-vim
        # yuck
        
        ;
    };
  };
}
