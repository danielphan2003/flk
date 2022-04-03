{pkgs, ...}: {
  home.packages = with pkgs; [ungoogled-chromium];

  home.sessionVariables.CHROME_EXECUTABLE = "${pkgs.ungoogled-chromium}/bin/chromium-browser";
}
