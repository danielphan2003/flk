{...}: {
  programs.waybar.settings.mainBar.network = {
    format-wifi = {
      format = " {essid} ";
      icon = "  ";
    };
    format-ethernet = {
      format = " {ifname} @ {ipaddr}/{cidr} ";
      icon = "  ";
    };
    format-linked = {
      format = " {ifname} (No IP) ";
      icon = "  ";
    };
    format-disconnected = {
      format = " Disconnected ";
      icon = "  ";
    };
    tooltip-format-wifi = " Signal Strength: {signalStrength}% ";
  };
}
