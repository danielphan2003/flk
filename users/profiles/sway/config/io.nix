{ ... }:
{
  input."type:keyboard" = {
    xkb_layout = "us";
    xkb_options = "grp:alt_shift_toggle";
    xkb_numlock = "enabled";
  };

  input."type:touchpad" = {
    tap = "enabled";
    natural_scroll = "enabled";
    scroll_method = "two_finger";
  };

  output."HDMI-A-1" = {
    mode = "1920x1080@75Hz";
    subpixel = "rgb";
    scale = "1.0";
  };
}
