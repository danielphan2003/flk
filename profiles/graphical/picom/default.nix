{
  services.picom = {
    enable = false;
    experimentalBackends = true;
    backend = "glx";
    vSync = true;
    refreshRate = 75;

    shadow = false;
    shadowOpacity = 0.75;
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'slop'"
      "class_g = 'Firefox' && argb"
      "class_g = 'Rofi'"
      "_GTK_FRAME_EXTENTS@:c"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
    ];

    fade = true;
    fadeSteps = [ 0.03 0.03 ];
    fadeDelta = 3;

    inactiveOpacity = 1.0;
    activeOpacity = 1.0;

    opacityRules = [
      "80:class_g = 'Alacritty'"
      "80:class_g = 'Wezterm'"
      "80:class_g = 'URxvt'"
      "80:class_g = 'UXTerm'"
      "80:class_g = 'XTerm'"
    ];

    settings = {
      shadow-radius = 12;
      shadow-offset-x = -12;
      shadow-offset-y = -12;

      shadow-color = "#000000";

      no-fading-openclose = false;
      no-fading-destroyed-argb = true;

      frame-opacity = 1;
      inactive-opacity-override = false;
      inactive-dim = 0.0;

      focus-exclude = [
        "class_g = 'Cairo-clock'"
        "class_g ?= 'rofi'"
        "class_g ?= 'slop'"
        "class_g ?= 'Steam'"
      ];

      blur = {
        method = "dual_kawase";
        strength = 5.0;
        deviation = 1.0;
        kernel = "11x11gaussian";
      };

      blur-background = false;
      blur-background-frame = true;
      blur-background-fixed = true;

      blur-background-exclude = [
        "class_g = 'slop'"
        "class_g = 'Firefox' && argb"
        "name = 'rofi - Global Search'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      dbus = false;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;

      unredir-if-possible-exclude = [ ];

      detect-transient = true;
      detect-client-leader = true;
      resize-damage = 1;

      invert-color-include = [ ];

      glx-no-stencil = true;
      use-damage = true;

      transparent-clipping = false;

      log-level = "warn";
      log-file = "~/.cache/picom-log.log";
      show-all-xerrors = true;

      wintypes = {
        tooltip = { fade = true; shadow = false; focus = false; };
        normal = { shadow = false; };
        dock = { shadow = false; };
        dnd = { shadow = false; };
        popup_menu = { shadow = true; focus = false; opacity = 0.90; };
        dropdown_menu = { shadow = false; focus = false; };
        above = { shadow = true; };
        splash = { shadow = false; };
        utility = { focus = false; shadow = false; blur-background = false; };
        notification = { shadow = false; };
        desktop = { shadow = false; blur-background = false; };
        menu = { focus = false; };
        dialog = { shadow = true; };
      };
    };
  };
}
