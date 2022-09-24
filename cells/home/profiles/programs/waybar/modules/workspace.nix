{...}: {
  programs.waybar.settings.mainBar."sway/workspaces" = {
    # disable-scroll = true;
    # all-outputs = true;
    format = "{icon}";
    format-icons = {
      "1" = "";
      "2" = "";
      "3" = "";
      "4" = "";
      "5" = "";
      "6" = "";
      "9" = "";
      "10" = "";
      "22" = "";
      focused = "";
      urgent = "";
      default = "";
    };
  };
}
