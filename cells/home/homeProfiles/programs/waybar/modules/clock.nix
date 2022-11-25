{...}: {
  programs.waybar.settings.mainBar.clock = {
    format = " {:%a at %d/%m → %H:%M:%S} ";
    format-icon = "  ";
    interval = 1;
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format-alt = {
      format = " {:%A, %d %b} ";
      icon = "  ";
    };
  };
}
