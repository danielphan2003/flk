{...}: {
  programs.waybar.settings.mainBar.backlight = {
    format = "{icon}";
    format-alt = "{percent}% {icon}";
    format-alt-click = "click-right";
    format-icons = ["○" "◐" "●"];
    on-scroll-down = "light -U 10";
    on-scroll-up = "light -A 10";
  };
}
