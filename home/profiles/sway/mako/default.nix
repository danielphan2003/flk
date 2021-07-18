{ pkgs, ... }: {
  programs.mako = {
    enable = true;
    anchor = "top-right";
    layer = "overlay";

    font = "SF Pro Display 11";

    backgroundColor = "#2D3748";
    progressColor = "source #718096";
    textColor = "#F7FAFC";
    padding = "15,20";
    margin = "0,10,10,0";
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

    borderSize = 0;
    borderRadius = 4;

    defaultTimeout = 10000;
    # extraConfig = ''
    #   [urgency=high]
    #   ignore-timeout=1
    #   text-color=#742A2A
    #   background-color=#FEB2B2
    #   progress-color=source #FC8181
    # '';
  };
}
