{ self, pkgs, ... }: {
  programs.thefuck.enable = true;

  environment.shellAliases = {
    # quick cd
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # git
    g = "git";

    # grep
    grep = "rg";
    gi = "grep -i";

    # internet ip
    myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";
    myipv6 = "ip -o -6 addr list eth0 | awk '{print $4}' | cut -d/ -f1";

    # nix
    n = "nix";
    np = "n profile";
    ni = "np install";
    nr = "np remove";
    ns = "n search --no-update-lock-file";
    nf = "n flake";
    nepl = "n repl '<nixpkgs>'";
    srch = "ns nixos";
    orch = "ns override";
    mn = ''
      manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
    '';

    # fix nixos-option
    nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

    # top
    top = "btm";

    # tailscale
    ts = "tailscale";
    sts = "sudo tailscale";

    # systemd
    ctl = "systemctl";
    stl = "sudo systemctl";
    utl = "systemctl --user";
    ut = "systemctl --user start";
    un = "systemctl --user stop";
    up = "sudo systemctl start";
    dn = "sudo systemctl stop";
    jtl = "journalctl";

    cat = "${pkgs.bat}/bin/bat";

    # dir action
    clr = "clear";
    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -v";
    mkd = "mkdir -pv";
    open = "xdg-open";

    diff = "diff --color=auto";

    # media
    yt = "${pkgs.youtube-dl}/bin/youtube-dl --add-metadata -i";
    yta = "yt -x -f bestaudio/best";
    ffmpeg = "ffmpeg -hide_banner";

    f = ''fzf \
      --preview-window=wrap \
      --preview 'bat --style=numbers --theme='OneHalfDark' --color=always {}' \
      --height=75% \
    '';

    # disk
    df = "duf";
    disks = "df / /boot /mnt/danie";
    du = "du -h";

    # dir info
    ls = "exa";
    l = "ls -lhg --git";
    la = "l -a";
    t = "l -T";
    ta = "la -T";

    ps = "${pkgs.procs}/bin/procs";

    rz = "exec zsh";
    v = "$EDITOR";
  };
}
