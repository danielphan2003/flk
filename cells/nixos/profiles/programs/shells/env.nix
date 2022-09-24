{
  self,
  pkgs,
  ...
}: {
  programs.thefuck.enable = true;

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSHISTFILE = "~/.local/share/history/lesshst";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    BAT_PAGER = "less";
  };

  environment.shellAliases = {
    diff = "diff --color=auto";
    clr = "clear";
    v = "$EDITOR";

    # cd quick actions
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # internet ip
    myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";
    myipv6 = "curl https://icanhazip.com";

    # systemd
    ctl = "systemctl";
    stl = "sudo systemctl";
    utl = "systemctl --user";
    ut = "systemctl --user start";
    un = "systemctl --user stop";
    up = "sudo systemctl start";
    dn = "sudo systemctl stop";
    jtl = "journalctl";
  };
}
