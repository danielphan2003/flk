{lib, ...}: let
  mkAdvancedWorkspaces = from: to: padding:
    lib.listToAttrs
    (map
      (x:
        lib.nameValuePair
        "super + {_,shift +}F${toString x}"
        "exec swaymsg {,move container to} workspace number ${toString (x + padding)}")
      (lib.range from to));
in {
  services.swhkd.keybindings = lib.mkMerge [
    {
      # Go to (or move window to) workspace number 1 to number 9
      "super + {_,shift +}{1-9}" = "exec swaymsg {,move container to} workspace number {1-9}";
    }

    ({
        # Go to (or move window to) workspace number 10 to number 22
        "super + {_,shift +}0" = "exec swaymsg {,move container to} workspace number 10";
      }
      // mkAdvancedWorkspaces 1 12 10)

    {
      # Shortcuts for easier navigation between workspaces
      "super + ctrl + {left,right}" = "exec swaymsg workspace {prev,next}";
      "super + tab" = "exec swaymsg workspace back_and_forth";
    }
  ];
}
