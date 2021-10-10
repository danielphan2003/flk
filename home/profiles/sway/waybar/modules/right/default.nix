args@{ pkgs, lib, ... }:
let
  inherit (lib)
    concatStringsSep
    head
    imap0
    remove
    splitString
    subtractLists
    ;

  where = x: xs:
    head (remove null (imap0 (i: v: if v == x then i else null) xs));
  waybarColorModule = final: prev:
    let
      args = final // prev;
      removedArgs = builtins.removeAttrs args [ "excludedLines" ];
      includedLines = [ "left_sep" "icon" "format" "right_sep" ];
      moduleStyle = pkgs.substituteAll ({
        src = ../../module.html;
        left_sep_size = 17500;
        left_sep = "";
        right_sep_size = 17500;
        right_sep = "";
        icon_size = 13000;
      } // final // prev);
      styles = splitString "\n" (lib.fileContents moduleStyle);
      mapExcludedLines =
        if args ? excludedLines
        then
          map
            (x: builtins.elemAt styles (where x includedLines))
            (subtractLists args.excludedLines includedLines)
        else styles;
    in
    concatStringsSep "" mapExcludedLines;

  battery = name: {
    bat = name;
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% ";
    format-plugged = "{capacity}% ";
    format-alt = "{time} {icon}";
    format-icons = [ "" "" "" "" "" ];
  };
in
{
  modules-right = [
    "idle_inhibitor"
    "tray"
    "pulseaudio"
    "network"
    "clock"
    "custom/power"
  ];

  idle_inhibitor =
    let
      mkWaybarColorModule = waybarColorModule {
        left_sep_bg = "#080808";
        left_sep_fg = "#a8cfff";
        icon_bg = "#a8cfff";
        icon_fg = "#080808";
        format_bg = "#74b2ff";
        format_fg = "#080808";
        right_sep_bg = "#080808";
        right_sep_fg = "#74b2ff";
      };
    in
    {
      format = mkWaybarColorModule {
        format = "";
        icon = "{icon}";
      };
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

  tray.spacing = 10;

  clock =
    let
      mkWaybarColorModule = waybarColorModule {
        left_sep_bg = "#080808";
        left_sep_fg = "#9fe5d8";
        icon_bg = "#9fe5d8";
        icon_fg = "#080808";
        format_bg = "#79dac8";
        format_fg = "#080808";
        right_sep_bg = "#080808";
        right_sep_fg = "#79dac8";
      };
    in
    {
      format = mkWaybarColorModule {
        format = " {:%a at %d/%m → %H:%M:%S} ";
        icon = "  ";
      };
      interval = 1;
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = mkWaybarColorModule {
        format = " {:%A, %d %b} ";
        icon = "  ";
      };
    };

  # cpu.format = "{usage}% ";

  # memory.format = "{}% ";

  # backlight = {
  #   format = "{icon}";
  #   format-alt = "{percent}% {icon}";
  #   format-alt-click = "click-right";
  #   format-icons = [ "○" "◐" "●" ];
  #   on-scroll-down = "light -U 10";
  #   on-scroll-up = "light -A 10";
  # };

  network =
    let
      mkWaybarColorModule = waybarColorModule {
        left_sep_bg = "#080808";
        left_sep_fg = "#eddbb5";
        icon_bg = "#eddbb5";
        icon_fg = "#080808";
        format_bg = "#e3c78a";
        format_fg = "#080808";
        right_sep_bg = "#080808";
        right_sep_fg = "#e3c78a";
      };
    in
    {
      format-wifi = mkWaybarColorModule {
        format = " {essid} ";
        icon = "  ";
      };
      format-ethernet = mkWaybarColorModule {
        format = " {ifname} @ {ipaddr}/{cidr} ";
        icon = "  ";
      };
      format-linked = mkWaybarColorModule {
        format = " {ifname} (No IP) ";
        icon = "  ";
      };
      format-disconnected = mkWaybarColorModule {
        format = " Disconnected ";
        icon = "  ";
      };
      tooltip-format-wifi = " Signal Strength: {signalStrength}% ";
    };

  pulseaudio =
    let
      mkWaybarColorModule = waybarColorModule {
        left_sep_bg = "#080808";
        left_sep_fg = "#f5baa8";
        icon_bg = "#f5baa8";
        icon_fg = "#080808";
        format_bg = "#f09479";
        format_fg = "#080808";
        right_sep_bg = "#080808";
        right_sep_fg = "#f09479";
      };
    in
    {
      scroll-step = 1;
      format = mkWaybarColorModule {
        format = "{volume}% {format_source} ";
        icon = " {icon} ";
      };
      format-bluetooth = mkWaybarColorModule {
        format = "{volume}% {format_source} ";
        icon = " {icon} ";
      };
      format-bluetooth-muted = mkWaybarColorModule {
        format = " Muted Speaker {format_source} ";
        icon = "   ";
      };
      format-muted = mkWaybarColorModule {
        format = " Muted Speaker {format_source} ";
        icon = "  ";
      };
      format-source = mkWaybarColorModule {
        format = " {volume}% ";
        icon = "  ";
      };
      format-source-muted = mkWaybarColorModule {
        format = " Muted Mic ";
        icon = "  ";
      };
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" "" ];
      };
      on-click = "pavucontrol";
    };

  "custom/power" =
    let
      mkWaybarColorModule = waybarColorModule {
        left_sep_bg = "#080808";
        left_sep_fg = "#ea8fa3";
        icon_bg = "#ea8fa3";
        icon_fg = "#080808";
        format_bg = "#e2637f";
        format_fg = "#080808";
        right_sep_bg = "#080808";
        right_sep_fg = "#ea8fa3";
        excludedLines = [ "format" ];
      };
    in
    {
      format = mkWaybarColorModule { icon = "   "; };
      on-click = "exec ${pkgs.nwg-launchers}/bin/nwgbar -o 0.2";
      escape = true;
      tooltip = false;
    };
}
