{ self, config, lib, pkgs, ... }:
let
  inherit (builtins) attrValues;
  inherit (lib) fileContents;
in
{
  imports = [
    ../cachix
    ./neovim
    ./peripherals
    ./zsh
  ];

  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.nixos.enable = false;

  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  environment = {

    systemPackages = attrValues {
      inherit (pkgs)
        nixFlakes
        binutils
        bottom
        cachix
        coreutils
        croc
        curl
        direnv
        dnsutils
        dosfstools
        fd
        fs-diff
        git
        gptfdisk
        iptables
        iputils
        jq
        manix
        nix-index
        ntfs3g
        moreutils
        nmap
        pciutils
        ripgrep
        skim
        tealdeer
        usbutils
        utillinux
        wget
        whois
        wireguard-tools
        ;
    };

    shellInit = ''
      export STARSHIP_CONFIG=${
        pkgs.writeText "starship.toml"
        (fileContents ./starship.toml)
      }
    '';

    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
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
        myipv6 = "dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6 2>&1";

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
        nrb = ifSudo "sudo nixos-rebuild";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # fix nixos-option
        nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

        # sudo
        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";

        # top
        top = "btm";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "s systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "s systemctl start";
        dn = ifSudo "s systemctl stop";
        jtl = "journalctl";

      };
  };

  fonts = {

    fonts = attrValues {
      inherit (pkgs)
        powerline-fonts
        dejavu_fonts
        ;
    };

    fontconfig.defaultFonts = {

      monospace = [ "DejaVu Sans Mono for Powerline" ];

      sansSerif = [ "DejaVu Sans" ];

    };

  };

  nix = {

    autoOptimiseStore = true;

    gc.automatic = true;

    optimise.automatic = true;

    useSandbox = true;

    allowedUsers = [ "@wheel" ];

    trustedUsers = [ "root" "@wheel" ];

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      builders-use-substitutes = true
    '';

  };

  programs.bash = {
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "192.168.0.0/16"
      "fe80::/64"
    ];
  };

  programs.ssh.startAgent = false;

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    allowSFTP = false;
    challengeResponseAuthentication = false;
    kexAlgorithms = [
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "diffie-hellman-group14-sha256"
    ];
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
    permitRootLogin = "no";
    openFirewall = lib.mkDefault false;
    extraConfig = ''
      #-------------------------------------------------------#
      # Login restrictions                                    #
      #-------------------------------------------------------#
      LoginGraceTime 30s
      StrictModes yes
      MaxAuthTries 3
      MaxSessions 5

      AuthenticationMethods publickey
      HostbasedAuthentication no
      IgnoreRhosts yes
      PermitEmptyPasswords no

      AllowAgentForwarding yes
      AllowTcpForwarding no
      X11Forwarding no
      StreamLocalBindUnlink yes

      PermitTTY yes
      PermitUserEnvironment no

      #-------------------------------------------------------#
      # Enable compression                                    #
      #-------------------------------------------------------#
      Compression yes

      ClientAliveInterval 600
      ClientAliveCountMax 0
      MaxStartups 10:30:100
      PermitTunnel no
      VersionAddendum none

      #-------------------------------------------------------#
      # Display a banner before authenticating to the system. #
      # Use your own /etc/issue.net file                      #
      #-------------------------------------------------------#
      Banner /etc/issue

      #-------------------------------------------------------#
      # Allow client to pass locale environment variables     #
      #-------------------------------------------------------#
      AcceptEnv LANG LC_*
    '';
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = lib.mkDefault "curses";
  };

  services.earlyoom.enable = true;

  security.protectKernelImage = true;

}
