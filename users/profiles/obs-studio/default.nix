{ pkgs, ... }: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-v4l2sink
      waylandPkgs.obs-wlrobs
    ];
  };
}
