{...}: {
  programs.waybar.settings.mainBar.pulseaudio = {
    scroll-step = 1;

    on-click = "pavucontrol";

    format = "{icon} {volume}% {format_source}";

    format-bluetooth = "{icon} {volume}% {format_source}";
    format-bluetooth-muted = "  Muted {format_source}";

    format-muted = " Muted {format_source}";

    format-source = " {volume}%";
    format-source-muted = " Muted";

    format-icons = {
      headphone = "";
      hands-free = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = ["" "" ""];
    };
  };
}
