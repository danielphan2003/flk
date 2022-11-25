{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      bat
      dasel
      du-dust
      duf
      exa
      fx
      fzf
      godu
      procs
      ripgrep
      sd
      skim
      ;
  };

  environment.shellAliases = {
    cat = "bat";
    f = ''      fzf \
            --preview-window=wrap \
            --preview 'bat --style=numbers --theme='OneHalfDark' --color=always {}' \
            --height=75% \
    '';
    ps = "procs";

    # disk
    df = "duf";
    disks = "df / /boot";
    du = "du -h";

    # dir action
    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -v";
    mkd = "mkdir -pv";
    open = "xdg-open";
    gd = "godu -print0 | xargs -0 rm -rf";
    gm = "godu -print0 | xargs -0 -I _ mv _ ";

    # dir info
    ls = "exa";
    l = "ls -lhg --git";
    la = "l -a";
    t = "l -T";
    ta = "la -T";

    # grep
    grep = "rg";
    gi = "grep -i";
  };
}
