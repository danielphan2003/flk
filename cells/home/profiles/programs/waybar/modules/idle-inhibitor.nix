{...}: {
  programs.waybar.settings.mainBar.idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "";
      deactivated = "";
    };
  };
}
