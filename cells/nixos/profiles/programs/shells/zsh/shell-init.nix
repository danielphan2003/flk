{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep mkBefore fileContents;
in {
  environment.etc.zshrc.text = mkBefore ''
    if [[ -r "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh" ]]; then
      source "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh"
    fi
  '';

  programs.zsh.promptInit = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

    # only use p10k-linux when interactive
    [[ -z $DISPLAY && -z $WAYLAND_DISPLAY ]] \
      && source ${./p10k/p10k-linux.zsh} \
      || source ${./p10k/p10k.zsh}
  '';

  programs.zsh.interactiveShellInit = let
    zshrc = fileContents ./zshrc;

    plugins = let
      mapSource = map (path: "source ${path}");

      sources = mapSource [
        ./cdr/cdr.zsh
        "${pkgs.skim}/share/skim/completion.zsh"
        "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
        "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
        "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
        "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
        "${pkgs.undistract-me}/etc/profile.d/undistract-me.sh"
        # "${zsh-prezto}/share/zsh-prezto/init.zsh"
      ];

      plugins = [
        "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
      ];
    in
      concatStringsSep "\n" (plugins ++ sources);

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
        mkdir -p $out/share/zsh/functions

        for file in $src/*; do
          substituteAll $file $out/share/zsh/functions/${basename}
          chmod 755 $out/share/zsh/functions/${basename}
        done
      '';
    };
  in ''
    ${plugins}

    fpath+=( ${functions}/share/zsh/functions )
    autoload -Uz ${functions}/share/zsh/functions/*(:t)

    ${zshrc}

    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
    eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
    source ${pkgs.skim}/share/skim/key-bindings.zsh

    # needs to remain at bottom so as not to be overwritten
    # bindkey jj vi-cmd-mode
  '';
}
