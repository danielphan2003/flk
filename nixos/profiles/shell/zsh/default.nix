{
  lib,
  pkgs,
  profiles,
  ...
}: let
  inherit (builtins) attrValues concatStringsSep;

  inherit (lib) fileContents;
  # wrapZshFunctions = pkgs.callPackage lib.our.wrapZshFunctions { };
in {
  imports = with profiles.shell; [aliases];

  users.defaultUserShell = pkgs.zsh;

  environment = {
    etc.zshrc.text = lib.mkBefore ''
      if [[ -r "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh" ]]; then
        source "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh"
      fi
    '';

    sessionVariables = let
      fd = "${pkgs.fd}/bin/fd -H";
    in {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      LESSHISTFILE = "~/.local/share/history/lesshst";
      LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
      BAT_PAGER = "less";
      SKIM_ALT_C_COMMAND = let
        alt_c_cmd = pkgs.writeScriptBin "cdr-skim.zsh" ''
          #!${pkgs.zsh}/bin/zsh
          ${fileContents ./cdr-skim.zsh}
        '';
      in "${alt_c_cmd}/bin/cdr-skim.zsh";
      SKIM_DEFAULT_COMMAND = fd;
      SKIM_CTRL_T_COMMAND = fd;
      ZDOTDIR = "~/.config/zsh";
    };
  };

  programs.zsh = {
    enable = true;

    enableGlobalCompInit = false;

    histSize = 10000;
    # histStamps = "dd/mm/yyyy";
    histFile = "~/.cache/zsh/history";

    setOptions = [
      "extendedglob"
      "incappendhistory"
      "sharehistory"
      "histignoredups"
      "histfcntllock"
      "histreduceblanks"
      "histignorespace"
      "histallowclobber"
      "autocd"
      "cdablevars"
      "nomultios"
      "pushdignoredups"
      "autocontinue"
      "promptsubst"
      "globdots"
    ];

    promptInit = let
      p10k = pkgs.writeText "pk10.zsh" (fileContents ./p10k.zsh);
      p10k-linux = pkgs.writeText "pk10-linux.zsh" (fileContents ./p10k-linux.zsh);
    in ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -z $DISPLAY && -z $WAYLAND_DISPLAY ]] \
        && source ${p10k-linux} \
        || source ${p10k}
    '';

    interactiveShellInit = let
      zshrc = fileContents ./zshrc;

      sources = with pkgs; [
        ./cdr.zsh
        "${skim}/share/skim/completion.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
        "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
        "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
        # "${zsh-prezto}/share/zsh-prezto/init.zsh"
      ];

      source = map (source: "source ${source}") sources;

      # functions = wrapZshFunctions {
      #   inherit (pkgs) ripgrep man exa;
      # };

      functions = pkgs.stdenv.mkDerivation {
        name = "zsh-functions";
        src = ./functions;

        inherit
          (pkgs)
          exa
          gst
          man
          ripgrep
          ;

        installPhase = let
          basename = "\${file##*/}";
        in ''
          mkdir $out

          for file in $src/*; do
            substituteAll $file $out/${basename}
            chmod 755 $out/${basename}
          done
        '';
      };

      plugins = concatStringsSep "\n" ([
          "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
        ]
        ++ source);
    in ''
      ${plugins}

      fpath+=( ${functions} )
      autoload -Uz ${functions}/*(:t)

      ${zshrc}

      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
      source ${pkgs.skim}/share/skim/key-bindings.zsh

      # needs to remain at bottom so as not to be overwritten
      # bindkey jj vi-cmd-mode
    '';
  };
}
