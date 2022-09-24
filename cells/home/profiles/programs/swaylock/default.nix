{pkgs, ...}: {
  home.packages = [pkgs.swaylock-effects pkgs.sway-physlock];

  programs.swaylock.settings = {
    indicator = true;
    clock = true;
    screenshots = true;
    indicator-radius = 100;
    indicator-thickness = 12;
    # effect-blur = "7x5";
    # line-color = "$BG";
    datestr = "%d-%m-%Y";
    show-failed-attempts = true;
    fade-in = 0.1;
    # effect-scale = 0.5;
    effect-blur = "8x3";
    effect-scale = 2;
    effect-vignette = "0.5:0.5";
    effect-compose = "100,-100;40x40;center;${./lock.svg}";
  };
}
