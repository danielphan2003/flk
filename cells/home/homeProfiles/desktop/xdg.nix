{pkgs, ...}: {
  home.packages = [pkgs.xdg_utils];

  home.sessionVariables = {
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    ASPELL_CONF = ''
      per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
      personal $XDG_CONFIG_HOME/aspell/en_US.pws;
      repl $XDG_CONFIG_HOME/aspell/en.prepl;
    '';
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    HISTFILE = "$XDG_DATA_HOME/bash/history";
    INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
    LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME/desk";
      documents = "$HOME/docs";
      download = "$HOME/dl";
      music = "$HOME/mus";
      pictures = "$HOME/pics";
      publicShare = "$HOME/pub";
      templates = "$HOME/docs/templates";
      videos = "$HOME/av";
    };
  };
}
