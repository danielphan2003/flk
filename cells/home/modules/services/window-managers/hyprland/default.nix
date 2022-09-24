{
  config,
  lib,
  pkgs,
  ...
}: {}
# with lib;
# let
#   cfg = config.wayland.windowManager.hyprland;
#   index = imap: el: list: let
#     idx = imap (i: v: if v == el then i else -1) list;
#   in if all (x: x == -1) idx then -1 else foldl' (i: v: if v != -1 then v else i) 0 idx;
#   index0 = index imap0;
#   index1 = index imap1;
#   types = let
#     floats = let
#       betweenDesc = lowest: highest:
#       "${toString lowest} and ${toString highest} (both inclusive)";
#       between = lowest: highest:
#         assert assertMsg (lowest <= highest)
#           "floats.between: lowest must be smaller than highest";
#         addCheck float (x: x >= lowest && x <= highest) // {
#           name = "floatBetween";
#           description = "float between ${betweenDesc lowest highest}";
#         };
#     in {inherit between;};
#     tags = {
#       id = mkOptionType {
#         name = "id";
#         description = "id tag";
#         check = isInt;
#         merge = mergeOneOption;
#       };
#       relativeId = mkOptionType {
#         name = "relativeId";
#         description = "relative id tag";
#         check = value:
#           (hasPrefix "+" value || hasPrefix "-" value) && isInt (toInt (removePrefix "+" value));
#         merge = mergeOneOption;
#       };
#       monitor = mkOptionType {
#         name = "monitor";
#         description = "monitor tag";
#         check = hasPrefix "mon:";
#         merge = mergeOneOption;
#       };
#       monitorRelativeId = mkOptionType {
#         name = "monitor";
#         description = "monitor tag";
#         check = value: hasPrefix "m+" value || hasPrefix "m-" value;
#         merge = mergeOneOption;
#       };
#       name = mkOptionType {
#         name = "name";
#         description = "name tag";
#         check = hasPrefix "name:";
#         merge = mergeOneOption;
#       };
#       special = mkOptionType {
#         name = "special";
#         description = "special tag";
#         check = hasPrefix "special:";
#         merge = mergeOneOption;
#       };
#     };
#   in lib.types // {
#     inherit floats tags;
#     direction = lib.types.enum ["l" "r" "u" "d"] // {
#       name = "workspace";
#       description = "direction value";
#       merge = mergeOneOption;
#     };
#     coordinate = {
#       screen = mkOptionType {
#         name = "coordinate";
#         description = "coordinate value";
#         check = value:
#           let
#             processed = splitString " " value;
#             isRelative = all isInt processed;
#             isAbsolute = all (x: x >= 0) (drop 1 processed);
#           in
#             isRelative || (hasPrefix "exact " value && isAbsolute);
#         merge = mergeOneOption;
#       };
#       workspace = lib.types.oneOf (builtins.attrValues (builtins.removeAttrs tags ["monitor"]));
#       monitor = types.either types.direction types.str;
#     };
#     transformEnum = types.enum ["normal" 90 180 270 "flipped" (-90) (-180) (-270)];
#   };
#   dispatchers = {
#     "exec"= types.str;
#     "killactive" = types.unspecified;
#     "workspace" = types.coordinate.workspace;
#     "movetoworkspace" = types.coordinate.workspace;
#     "movetoworkspacesilent" = types.coordinate.workspace;
#     "togglefloating" = types.unspecified;
#     "fullscreen" = types.enum ["real" "maximize"];
#     "pseudo" = types.unspecified;
#     "movefocus" = types.direction;
#     "movewindow" = types.either types.direction tags.monitor;
#     "resizeactive" = types.coordinate.screen;
#     "moveactive" = types.coordinate.screen;
#     "cyclenext" = types.enum [null "prev"];
#     "focuswindow" = types.str;
#     "focusmonitor" = types.oneOf [types.direction types.str types.tags.id];
#     "splitratio" =
#       addCheck types.float
#         (x: (types.floats.between 0.1 1.9).check (if x < 0 then x * -1 else x));
#     "movecursortocorner" = types.oneOf [types.direction (types.enum ["bottom-left" "bottom-right" "top-right" "top-left"])];
#     "workspaceopt" = types.enum ["allfloat" "allpseudo"];
#     "exit" = types.unspecified;
#     "forcerendererreload" = types.unspecified;
#     "movecurrentworkspacetomonitor" = types.coordinate.monitor;
#     "moveworkspacetomonitor" =
#       addCheck types.str
#         (x: let processed = splitString " " x; in
#           types.tags.id.check (head x) && types.coordinate.monitor.check (last x));
#     "togglespecialworkspace" = types.unspecified;
#   };
#   bindOpts = {name, config, ...}: {
#     options = {
#       enable = mkEnableOption "this keybinding";
#       keybindings = mkOption {
#         type = types.either types.str (types.listOf types.str);
#         description = ''
#           The keybinding of the bind. If undefined, the name of the
#           attribute set will be used.
#         '';
#       };
#       dispatcher = mkOption {
#         type = types.enum (attrNames dispatchers);
#         default = "exec";
#         description = "dispatcher to use in the action";
#       };
#       params = mkOption {
#         type = dispatchers."${config.dispatcher}" or types.oneOf (builtins.attrValues dispatchers);
#         apply = x: warnIf (types.tags.special.check x && config.dispatcher != "movetoworkspace") ''
#           [Hyprland] `special` is supported ONLY on `movetoworkspace`.
#           Any other dispatcher will result in undocumented behavior.
#         '' x;
#         default = null;
#         description = "parameters to pass to dispatcher";
#       };
#       lock = mkEnableOption "locking this keybinding to make it work even with an active inhibitor, e.g. screen locked";
#     };
#     config = {
#       keybindings = mkDefault name;
#     };
#   };
#   monitorOpts = {name, config, ...}: {
#     options = {
#       enable = mkEnableOption "the monitor";
#       name = mkOption {
#         type = types.str;
#         description = ''
#           The name of the monitor. If undefined, the name of the
#           attribute set will be used.
#         '';
#       };
#       resolution = mkOption {
#         type = types.nullOr types.str;
#         default = null;
#         description = "Set monitor resolution.";
#       };
#       offset = mkOption {
#         type = types.nullOr types.str;
#         default = null;
#         description = ''
#           Set monitor offset.
#           Please use the offset for its intended purpose before asking stupid questions
#           about "fixing" monitors being mirrored.
#           Please remember the offset is calculated with the scaled resolution,
#           meaning if you want your 4K monitor with scale 2 to the left of your 1080p one,
#           you'd use the offset 1920x0 for the second screen. (3840 / 2)
#         '';
#       };
#       scale = mkOption {
#         type = types.nullOr types.float;
#         default = 1;
#         description = "Set monitor scale";
#       };
#       reserved = mkOption {
#         type =
#           let
#             mkMonitorReservedOption = position:
#               mkOption {
#                 type = types.int;
#                 default = 0;
#                 description = "in pixels, the reserved area to add to ${position}";
#               };
#           in
#             types.nullOr (types.submodule {
#               top = mkMonitorReservedOption "top";
#               bottom = mkMonitorReservedOption "bottom";
#               left = mkMonitorReservedOption "left";
#               right = mkMonitorReservedOption "right";
#             });
#         default = {};
#       };
#       defaultWorkspace = mkOption {
#         type = types.nullOr types.int;
#         default = null;
#         description = "set default workspace for the monitor";
#       };
#       transform = mkOption {
#         type = types.transformEnum;
#         default = "normal";
#         description = "set monitor rotation";
#       };
#     };
#     config = {
#       name = mkDefault name;
#     };
#   };
#   execOpts = types.submodule {
#     options = {
#       command = mkOption {
#         type = types.nullOr types.str;
#         default = null;
#         description = "execute a shell script";
#       };
#       always = mkEnableOption "executing a shell script on each reload";
#     };
#   };
#   input = {
#     kb_layout = mkOption {
#       type = types.str;
#       default = null;
#       description = "keyboard layout";
#     };
#     kb_variant = mkOption {
#       type = types.str;
#       default = null;
#       description = "keyboard variant";
#     };
#     kb_model = mkOption {
#       type = types.str;
#       default = null;
#       description = "keyboard model";
#     };
#     kb_options = mkOption {
#       type = types.str;
#       default = null;
#       description = "keyboard options";
#     };
#     kb_rules = mkOption {
#       type = types.str;
#       default = null;
#       description = "keyboard rules";
#     };
#     follow_mouse = mkOption {
#       type = types.enum [false "full" "loose"];
#       default = "full";
#       description = ''
#         Enable mouse following (focus on enter new window).
#         Quirk: will always focus on mouse enter if you're entering a floating window
#         from a tiled one, or vice versa.
#         Loose will focus mouse on other windows on focus but not the keyboard.
#       '';
#     };
#     repeat_rate = mkOption {
#       type = types.int;
#       default = 25;
#       description = "in ms, the repeat rate for held keys";
#     };
#     repeat_delay = mkOption {
#       type = types.int;
#       default = 600;
#       description = "in ms, the repeat delay (grace period) before the spam";
#     };
#     natural_scroll = mkOption {
#       type = types.bool;
#       default = false;
#       description = "enable natural scroll";
#     };
#     numlock_by_default = mkOption {
#       type = types.bool;
#       default = false;
#       description = "lock numlock by default";
#     };
#     force_no_accel = mkOption {
#       type = types.bool;
#       default = false;
#       description = "force no mouse acceleration, bypasses most of your pointer settings to get as raw of a signal as possible.";
#     };
#     touchpad = {
#       disable_while_typing = mkOption {
#         type = types.bool;
#         default = true;
#         description = "disable trackpad while typing";
#       };
#       natural_scroll = mkOption {
#         type = types.bool;
#         default = false;
#         description = "use natural scroll";
#       };
#       clickfinger_behavior = mkOption {
#         type = types.bool;
#         default = false;
#         description = "use click finger behaviour for trackpad";
#       };
#       middle_button_emulation = mkOption {
#         type = types.bool;
#         default = false;
#         description = "middle button emulation for trackpad";
#       };
#       tap-to-click = mkOption {
#         type = types.bool;
#         default = true;
#         description = "tap on trackpad to click";
#       };
#     };
#   };
#   deviceOpts = {name, config, ...}: {
#     options = builtins.removeAttrs inputs ["force_no_accel" "follow_mouse"] // {
#       name = mkOption {
#         type = types.str;
#         description = ''
#           The name of the device. If undefined, the name of the
#           attribute set will be used.
#         '';
#       };
#     };
#     config = {
#       name = mkDefault name;
#     };
#   };
#   configModule = types.submodule {
#     options = {
#       inherit inputs;
#       general = mkOption {
#         sensitivity = mkOption {
#           type = types.float;
#           default = 1.0;
#           description = "mouse sensitivity";
#         };
#         apply_sens_to_raw = mkOption {
#           type = types.bool;
#           default = false;
#           description = "if on, will also apply the sensitivity to raw mouse output (e.g. sensitivity in games)";
#         };
#         main_mod = mkOption {
#           type = types.str;
#           default = "SUPER";
#           description = "the mod used to move/resize windows (hold main_mod and LMB/RMB, try it and you'll know what I mean.)";
#         };
#         border_size = mkOption {
#           type = types.int;
#           default = 2;
#           description = "border thickness";
#         };
#         no_border_on_floating = mkOption {
#           type = types.bool;
#           default = false;
#           description = "disable borders for floating windows.";
#         };
#         gaps_in = mkOption {
#           type = types.int;
#           default = 5;
#           description = "gaps between windows";
#         };
#         gaps_out = mkOption {
#           type = types.int;
#           default = 20;
#           description = "gaps between window-monitor edge";
#         };
#         col.active_border = mkOption {
#           type = types.str;
#           default = "0x66ee1111";
#           description = "color of active border";
#         };
#         col.inactive_border = mkOption {
#           type = types.str;
#           default = "0x66333333";
#           description = "color of inactive border";
#         };
#         cursor_inactive_timeout = mkOption {
#           type = types.int;
#           default = 0;
#           description = "in seconds, after how many seconds of cursor's inactivity to hide it. (default / never is 0)";
#         };
#         damage_tracking = mkOption {
#           type = types.enum ["none" "monitor" "full"];
#           default = "full";
#           description = "Makes the compositor redraw only the needed bits of the display. Saves on resources by not redrawing when not needed. Available modes: none, monitor, full. Heavily recommended to use full for maximum optimization.";
#         };
#       };
#       decoration = mkOption {
#         rounding = mkOption {
#           types = types.int;
#           default = 10;
#           description = "rounded corners radius (in pixels)";
#         };
#         multisample_edges = mkOption {
#           types = types.bool;
#           default = true;
#           description = "enable antialiasing (no-jaggies) for rounded corners.";
#         };
#         no_blur_on_oversized = mkOption {
#           types = types.bool;
#           default = true;
#           description = "disable blur on oversized windows (recommended to leave at default 1, may cause graphical issues)";
#         };
#         active_opacity = mkOption {
#           types = types.float;
#           default = 1.0;
#           description = "opacity of active window";
#         };
#         inactive_opacity = mkOption {
#           types = types.float;
#           default = 1.0;
#           description = "opacity of inactive window";
#         };
#         fullscreen_opacity = mkOption {
#           types = types.float;
#           default = 1.0;
#           description = "opacity of fullscreen window";
#         };
#         blur = mkOption {
#           types = types.bool;
#           default = true;
#           description = "enable dual kawase window background blur";
#         };
#         blur_size = mkOption {
#           types = types.int;
#           default = 8;
#           description = "Minimum 1, blur size (intensity)";
#         };
#         blur_passes = mkOption {
#           types = types.int;
#           default = 1;
#           description = ''
#             Minimim 1, more passes = more resource intensive.";
#             Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
#             If you want heavy blur, you need to up the blur_passes.
#             The more passes, the more you can up the blur_size without noticing artifacts.
#           '';
#         };
#         blur_ignore_opacity = mkOption {
#           types = types.bool;
#           default = false;
#           description = "make the blur layer ignore the opacity of the window.";
#         };
#         drop_shadow = mkOption {
#           types = types.bool;
#           default = true;
#           description = "enable drop shadows on windows";
#         };
#         shadow_range = mkOption {
#           types = types.int;
#           default = 4;
#           description = "Shadow range (in pixels), more = larger shadow";
#         };
#         shadow_render_power = mkOption {
#           types = types.ints.between 1 4;
#           default = 3;
#           description = "(1 - 4), in what power to render the falloff (more power, the faster the falloff)";
#         };
#         shadow_ignore_window = mkOption {
#           types = types.bool;
#           default = true;
#           description = "if true, the shadow will not be rendered behind the window itself, only around it.";
#         };
#         col.shadow = mkOption {
#           types = types.str;
#           default = "0xee1a1a1a";
#           description = "shadow's color. Alpha dictates shadow's opacity.";
#         };
#         shadow_offset = mkOption {
#           types = types.listOf int;
#           description = "shadow's rendering offset.";
#         };
#       };
#       animations =
#         let
#           mkAnimationOption = {name, description, styles ? []}:
#             {
#               enable = mkEnableOption "animation for ${name}: ${description}";
#               speed = mkOption {
#                 type = types.float;
#                 default = 0;
#                 description = "the amount of ds (1ds = 100ms) the animation will take";
#               };
#               curve = mkOption {
#                 type = types.str;
#                 default = "default";
#                 description = "the bezier curve name, define your own in config.bezier";
#               };
#             } // (optionalAttrs (styles != []) {
#               style = mkOption {
#                 type = types.nullOr (types.enum styles);
#                 default = null;
#                 description = "the animation style";
#               };
#             });
#         in
#         {
#           enable = mkEnableOption "animations";
#           windows = mkAnimationOption {
#             name = "windows";
#             description = "window movement/resizing - Styles: slide,popin (fallback is popin)";
#             styles = ["slide" "popin"];
#           };
#           borders = mkAnimationOption {
#             name = "borders";
#             description = "border color";
#             styles = [];
#           };
#           fadein = mkAnimationOption {
#             name = "fadein";
#             description = "fadein/fadeout on window open/close";
#             styles = [];
#           };
#           workspaces = mkAnimationOption {
#             name = "workspaces";
#             description = "workspace change";
#             styles = ["slide" "slidevert" "fadein"];
#           };
#         };
#       gestures = {
#         workspace_swipe = mkEnableOption "workspace swipe gesture";
#         workspace_swipe_distance = mkOption {
#           type = types.int;
#           default = 0;
#           description = "in px, the distance of the gesture";
#         };
#         workspace_swipe_invert = mkOption {
#           type = types.bool;
#           default = true;
#           description = "invert the direction";
#         };
#         workspace_swipe_min_speed_to_force = mkOption {
#           type = types.int;
#           default = 30;
#           description = ''
#             minimum speed in px per timepoint to force the change ignoring cancel_ratio
#             Setting to 0 will disable this mechanic.
#           '';
#         };
#         workspace_swipe_cancel_ratio = mkOption {
#           type = types.floats.between 0.0 1.0;
#           default = 0.5;
#           description = ''
#             how much the swipe has to proceed in order to commence it.
#             (0.7 -> if > 0.7 * distance, switch, if less, revert)
#           '';
#         };
#       };
#       misc = {
#         disable_hyprland_logo = mkOption {
#           type = types.bool;
#           default = false;
#           description = "disables the hyprland logo background.";
#         };
#         disable_splash_rendering = mkOption {
#           type = types.bool;
#           default = false;
#           description = "disables the hyprland splash rendering. (requires a monitor reload to take effect)";
#         };
#         no_vfr = mkOption {
#           type = types.bool;
#           default = true;
#           description = "disables VFR (variable frame rate) - VFR increases battery life at the expense of possible issues on a few monitors. (VFR is off by default)";
#         };
#       };
#       debug = {
#         overlay = mkOption {
#           type = types.bool;
#           default = false;
#           description = "print the debug performance overlay.";
#         };
#         damage_blink = mkOption {
#           type = types.bool;
#           default = false;
#           apply = x: warnIf x "[Hyprland] Epilepsy warning! Hyprland will FLASH areas updated with damage tracking!" x;
#           description = "(epilepsy warning!) flash areas updated with damage tracking.";
#         };
#       };
#       device = mkOption {
#         type = types.attrsOf (types.submodule deviceOpts);
#         default = {};
#         description = ''
#           Per-device config options will overwrite your options set in the input section.
#           It's worth noting that ONLY values explicitly changed will be overwritten.
#           Warning: Some configs, notably touchpad ones, require a Hyprland restart.
#         '';
#       };
#       monitor = mkOption {
#         type = types.attrsOf (types.submodule monitorOpts);
#         default = {};
#         description = "Monitor-specific settings";
#       };
#       bind = mkOption {
#         type = types.attrsOf (types.submodule bindOpts);
#         default = mapAttrs (n: mkOptionDefault) {
#           "${cfg.config.general.main_mod},Q" = {params = "kitty";};
#           "${cfg.config.general.main_mod},C" = {dispatcher = "killactive";};
#           "${cfg.config.general.main_mod},M" = {dispatcher = "exit";};
#           "${cfg.config.general.main_mod},E" = {params = "dolphin";};
#           "${cfg.config.general.main_mod},V" = {dispatcher = "togglefloating";};
#           "${cfg.config.general.main_mod},R" = {params = "wofi --show drun -o DP-3";};
#           "${cfg.config.general.main_mod},P" = {dispatcher = "pseudo";};
#           "${cfg.config.general.main_mod},left" = {dispatcher = "movefocus"; params = "l";};
#           "${cfg.config.general.main_mod},right" = {dispatcher = "movefocus"; params = "r";};
#           "${cfg.config.general.main_mod},up" = {dispatcher = "movefocus"; params = "u";};
#           "${cfg.config.general.main_mod},down" = {dispatcher = "movefocus"; params = "d";};
#           "${cfg.config.general.main_mod},1" = {dispatcher = "workspace"; params = 1;};
#           "${cfg.config.general.main_mod},2" = {dispatcher = "workspace"; params = 2;};
#           "${cfg.config.general.main_mod},3" = {dispatcher = "workspace"; params = 3;};
#           "${cfg.config.general.main_mod},4" = {dispatcher = "workspace"; params = 4;};
#           "${cfg.config.general.main_mod},5" = {dispatcher = "workspace"; params = 5;};
#           "${cfg.config.general.main_mod},6" = {dispatcher = "workspace"; params = 6;};
#           "${cfg.config.general.main_mod},7" = {dispatcher = "workspace"; params = 7;};
#           "${cfg.config.general.main_mod},8" = {dispatcher = "workspace"; params = 8;};
#           "${cfg.config.general.main_mod},9" = {dispatcher = "workspace"; params = 9;};
#           "${cfg.config.general.main_mod},0" = {dispatcher = "workspace"; params = 10;};
#           "ALT,1" = {dispatcher = "movetoworkspace"; params = 1;};
#           "ALT,2" = {dispatcher = "movetoworkspace"; params = 2;};
#           "ALT,3" = {dispatcher = "movetoworkspace"; params = 3;};
#           "ALT,4" = {dispatcher = "movetoworkspace"; params = 4;};
#           "ALT,5" = {dispatcher = "movetoworkspace"; params = 5;};
#           "ALT,6" = {dispatcher = "movetoworkspace"; params = 6;};
#           "ALT,7" = {dispatcher = "movetoworkspace"; params = 7;};
#           "ALT,8" = {dispatcher = "movetoworkspace"; params = 8;};
#           "ALT,9" = {dispatcher = "movetoworkspace"; params = 9;};
#           "ALT,0" = {dispatcher = "movetoworkspace"; params = 10;};
#         };
#         defaultText = "Default hyprland keybindings.";
#         description = ''
#           An attribute set that assigns a key press to an action using a key symbol.
#           See <link xlink:href="https://github.com/hyprwm/Hyprland/wiki/Advanced-config#binds"/>.
#           </para><para>
#           Consider to use <code>lib.mkOptionDefault</code> function to extend or override
#           default keybindings instead of specifying all of them from scratch.
#         '';
#         example = literalExpression ''
#           let
#             main_mod = config.wayland.windowManager.hyprland.config.main_mod;
#           in lib.mkOptionDefault {
#             "''${main_mod}+Return" = {params = "${cfg.config.terminal}";};
#             "''${main_mod}+Shift+q" = {dispatcher = "kill";};
#             "''${main_mod}+d" = {params = "${cfg.config.menu}";};
#           }
#         '';
#       };
#       exec = mkOption {
#         type = types.listOf execOpts;
#         default = [];
#         description = "A list of commands to run either on launch or on each reload.";
#       };
#       bezier = mkOption {
#         type = types.attrsOf (types.listOf types.floats.between 0.0 1.0);
#         default = {};
#         example = { overshot = [0.05 0.9 0.1 1.0]; };
#         description = ''
#           An attribute set that contains definitions of your own Bezier curve.
#           A good website to design your bezier can be found here <link xlink:href="https://www.cssportal.com/css-cubic-bezier-generator"/>.
#         '';
#       };
#       windowrule = mkOption {
#         type = types.attrsOf (types.either types.str (types.listOf type.str));
#         default = {};
#         example = { "^(kitty)$" = "float"; "title:^(Firefox)(.*)$" = ["move 0 0" "float"]; "WINDOW" = "RULE"; };
#         description = ''
#           Set window rules for various actions. These are applied on window open.
#           WINDOW is a RegEx, either:
#           - plain regex (for matching a window class)
#           - title: followed by a regex (for matching a window's title)
#           RULE is a rule (and a param if applicable)
#         '';
#       };
#       settings = mkOption {
#         type = types.submodule { freeformType = types.attrsOf (types.either types.str (types.listOf type.str)); };
#         default = {};
#         description = ''
#           An attribute set that defines other settings, like defining
#           variables and sourcing (multi-file).
#         '';
#       };
#     };
#   };
#   startupEntryStr = {command, always, ...}: ''
#     ${if always then "exec" else "exec-once"}=${command}
#   '';
#   bindEntryStr = {enable, keybindings, dispatcher, params, lock, ...}: ''
#     ${if lock then "bindl" else "bind"}=${keybindings},${dispatcher},${params}
#     ${optionalString (!enable) "unbind=${keybindings}"}
#   '';
#   valueNormalize = value:
#     if isBool value
#     then
#       if value then "1" else "0"
#     else
#       if isFloat value then floatToString value else toString value;
#   moduleStr = moduleType: name: attrs: ''
#     ${moduleType}:${attrs.name or name} {
#     ${concatStringsSep "\n"
#     (mapAttrsToList (name: value: "${name} ${value}") attrs)}
#     }
#   '';
#   monitorStr = {enable, name, resolution, offset, scale, reserved, defaultWorkspace, transform, ...}: ''
#     ${optionalString (!enable) "monitor=${name},disable"}
#     ${optionalString (reserved != {})
#       "monitor=${name},addreserved,${reserved.top},${reserved.bottom},${reserved.left},${reserved.right}"
#     }
#     ${optionalString (defaultWorkspace != null) "workspace=${name},${defaultWorkspace}"}
#     monitor=${name},${resolution},${offset},${scale}
#     monitor=${name},transform,${index transform types.transformEnum.functor.payload}
#   '';
#   inputStr = moduleStr "input";
#   configFile = pkgs.writeText "hyprland.conf" (concatStringsSep "\n"
#     ((if cfg.config != null then
#       with cfg.config;
#       ([
#         (fontConfigStr fonts)
#         "floating_main_mod ${floating.main_mod}"
#         (windowBorderString window floating)
#         "hide_edge_borders ${window.hideEdgeBorders}"
#         "focus_wrapping ${lib.hm.booleans.yesNo focus.forceWrapping}"
#         "focus_follows_mouse ${focus.followMouse}"
#         "focus_on_window_activation ${focus.newWindow}"
#         "mouse_warping ${if focus.mouseWarping then "output" else "none"}"
#         "workspace_layout ${workspaceLayout}"
#         "workspace_auto_back_and_forth ${
#           lib.hm.booleans.yesNo workspaceAutoBackAndForth
#         }"
#         "client.focused ${colorSetStr colors.focused}"
#         "client.focused_inactive ${colorSetStr colors.focusedInactive}"
#         "client.unfocused ${colorSetStr colors.unfocused}"
#         "client.urgent ${colorSetStr colors.urgent}"
#         "client.placeholder ${colorSetStr colors.placeholder}"
#         "client.background ${colors.background}"
#         (keybindingsStr {
#           keybindings = keybindingDefaultWorkspace;
#           bindsymArgs =
#             lib.optionalString (cfg.config.bindkeysToCode) "--to-code";
#         })
#         (keybindingsStr {
#           keybindings = keybindingsRest;
#           bindsymArgs =
#             lib.optionalString (cfg.config.bindkeysToCode) "--to-code";
#         })
#         (keycodebindingsStr keycodebindings)
#       ] ++ mapAttrsToList inputStr input
#         ++ mapAttrsToList outputStr output # outputs
#         ++ mapAttrsToList seatStr seat # seats
#         ++ mapAttrsToList (modeStr cfg.config.bindkeysToCode) modes # modes
#         ++ mapAttrsToList assignStr assigns # assigns
#         ++ map barStr bars # bars
#         ++ optional (gaps != null) gapsStr # gaps
#         ++ map floatingCriteriaStr floating.criteria # floating
#         ++ map windowCommandsStr window.commands # window commands
#         ++ map startupEntryStr startup # startup
#         ++ map workspaceOutputStr workspaceOutputAssign # custom mapping
#       )
#     else
#       [ ]) ++ (optional cfg.systemdIntegration ''
#         exec "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY hyprlandSOCK XDG_CURRENT_DESKTOP; systemctl --user start hyprland-session.target"'')
#       ++ (optional (!cfg.xwayland) "xwayland disable") ++ [ cfg.extraConfig ]));
#   defaulthyprlandPackage = pkgs.hyprland.override {
#     extraSessionCommands = cfg.extraSessionCommands;
#     extraOptions = cfg.extraOptions;
#     withBaseWrapper = cfg.wrapperFeatures.base;
#     withGtkWrapper = cfg.wrapperFeatures.gtk;
#   };
# in {
#   meta.maintainers = with maintainers; [ alexarice sumnerevans sebtm oxalica ];
#   options.wayland.windowManager.hyprland = mkOption {
#     enable = mkEnableOption "hyprland wayland compositor";
#     package = mkOption {
#       type = with types; nullOr package;
#       default = defaulthyprlandPackage;
#       defaultText = literalExpression "${pkgs.hyprland}";
#       description = ''
#         hyprland package to use. Will override the options
#         'wrapperFeatures', 'extraSessionCommands', and 'extraOptions'.
#         Set to <code>null</code> to not add any hyprland package to your
#         path. This should be done if you want to use the NixOS hyprland
#         module to install hyprland.
#       '';
#     };
#     systemdIntegration = mkOption {
#       type = types.bool;
#       default = pkgs.stdenv.isLinux;
#       example = false;
#       description = ''
#         Whether to enable <filename>hyprland-session.target</filename> on
#         hyprland startup. This links to
#         <filename>graphical-session.target</filename>.
#         Some important environment variables will be imported to systemd
#         and dbus user environment before reaching the target, including
#         <itemizedlist>
#           <listitem><para><literal>DISPLAY</literal></para></listitem>
#           <listitem><para><literal>WAYLAND_DISPLAY</literal></para></listitem>
#           <listitem><para><literal>hyprlandSOCK</literal></para></listitem>
#           <listitem><para><literal>XDG_CURRENT_DESKTOP</literal></para></listitem>
#         </itemizedlist>
#       '';
#     };
#     xwayland = mkOption {
#       type = types.bool;
#       default = true;
#       description = ''
#         Enable xwayland, which is needed for the default configuration of hyprland.
#       '';
#     };
#     wrapperFeatures = mkOption {
#       type = wrapperOptions;
#       default = { };
#       example = { gtk = true; };
#       description = ''
#         Attribute set of features to enable in the wrapper.
#       '';
#     };
#     extraSessionCommands = mkOption {
#       type = types.lines;
#       default = "";
#       example = ''
#         export SDL_VIDEODRIVER=wayland
#         # needs qt5.qtwayland in systemPackages
#         export QT_QPA_PLATFORM=wayland
#         export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
#         # Fix for some Java AWT applications (e.g. Android Studio),
#         # use this if they aren't displayed properly:
#         export _JAVA_AWT_WM_NONREPARENTING=1
#       '';
#       description = ''
#         Shell commands executed just before hyprland is started.
#       '';
#     };
#     extraOptions = mkOption {
#       type = types.listOf types.str;
#       default = [ ];
#       example = [
#         "--verbose"
#         "--debug"
#         "--unsupported-gpu"
#         "--my-next-gpu-wont-be-nvidia"
#       ];
#       description = ''
#         Command line arguments passed to launch hyprland. Please DO NOT report
#         issues if you use an unsupported GPU (proprietary drivers).
#       '';
#     };
#     config = mkOption {
#       type = types.nullOr configModule;
#       default = { };
#       description = "hyprland configuration options.";
#     };
#     extraConfig = mkOption {
#       type = types.lines;
#       default = "";
#       description =
#         "Extra configuration lines to add to ~/.config/hyprland/config.";
#     };
#   };
#   config = mkIf cfg.enable (mkMerge [
#     (mkIf (cfg.config != null) {
#       warnings = (optional (isList cfg.config.fonts)
#         "Specifying hyprland.config.fonts as a list is deprecated. Use the attrset version instead.")
#         ++ flatten (map (b:
#           optional (isList b.fonts)
#           "Specifying hyprland.config.bars[].fonts as a list is deprecated. Use the attrset version instead.")
#           cfg.config.bars);
#     })
#     {
#       assertions = [
#         (hm.assertions.assertPlatform "wayland.windowManager.hyprland" pkgs
#           platforms.linux)
#       ];
#       home.packages = optional (cfg.package != null) cfg.package
#         ++ optional cfg.xwayland pkgs.xwayland;
#       xdg.configFile."hyprland/config" = let
#         hyprlandPackage = if cfg.package == null then pkgs.hyprland else cfg.package;
#       in {
#         source = configFile;
#         onChange = ''
#           hyprlandSocket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/hyprland-ipc.$UID.$(${pkgs.procps}/bin/pgrep --uid $UID -x hyprland || true).sock"
#           if [ -S "$hyprlandSocket" ]; then
#             ${hyprlandPackage}/bin/hyprlandmsg -s $hyprlandSocket reload
#           fi
#         '';
#       };
#       systemd.user.targets.hyprland-session = mkIf cfg.systemdIntegration {
#         Unit = mkOption {
#           Description = "hyprland compositor session";
#           Documentation = [ "man:systemd.special(7)" ];
#           BindsTo = [ "graphical-session.target" ];
#           Wants = [ "graphical-session-pre.target" ];
#           After = [ "graphical-session-pre.target" ];
#         };
#       };
#       systemd.user.targets.tray = mkOption {
#         Unit = mkOption {
#           Description = "Home Manager System Tray";
#           Requires = [ "graphical-session-pre.target" ];
#         };
#       };
#     }
#   ]);
# }

