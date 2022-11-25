{...}: {
  programs.waybar.settings.mainBar.battery = {
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% ";
    format-plugged = "{capacity}% ";
    format-alt = "{time} {icon}";
    format-icons = ["" "" "" "" ""];
  };
}
