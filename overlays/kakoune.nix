final: prev: {
  kakoune = prev.kakoune.override {
    configure.plugins = with final.kakounePlugins; [
      kak-fzf
      (kak-fzf.override { fzf = final.skim; })
      kak-auto-pairs
      kak-buffers
      kak-powerline
      kak-vertical-selection
    ];
  };

  # wrapper to specify config dir
  kakoune-config = prev.writeShellScriptBin "k" ''
    XDG_CONFIG_HOME=/etc/xdg exec ${final.kakoune}/bin/kak "$@"
  '';
}
