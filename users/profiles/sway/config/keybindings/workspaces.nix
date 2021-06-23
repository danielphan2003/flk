{ mod, lib, ... }:
let
  # inherit (lib.our.mkCustomI3Bindsym) mkWorkspaceBindsym;

  # concatKeys = final: prev: intersperse "+" (prev ++ final);

  # genBindsyms = kRange: kBindsym:
  #   forEach
  #   (range kRange.head kRange.tail)
  #   (x: nameValuePair "${kBindsym.key (toString x)}" "${kBindsym.command (toString x)}");

  # mkWsList = range: { key, number ? true, moveModifier ? "Shift" }:
  #   let
  #     numbered = optionalString number "number";
  #     goToWs = x: {
  #       key = concatKeys key [ "${x}";
  #       command = "workspace ${numbered} ${x}";
  #     };
  #     moveToWs = x: {
  #       key = concatKeys key "${k}";
  #       command = "move container to ${goToWs.command x}";
  #     };
  #   in genBindsyms range {
  #     key = 
  #     command = 
  #   };

  # mkWs = workspaces:
  #   ;
  
  # workspaces = mkWs [
  #   (mkWsList [ 1 10 ] { key = "${mod}"; })
  #   (mkWsList [ 1 10 ] { key = "${mod}+KP_"; })
  #   (mkWsList [ 1 12 ] { key = "${mod}+F"; })
  # ];

  # preKey = x:
  #   let
  #     isFnKey = lib.optionalString (x > 9 && x < 23);
  #     keyToStr = builtins.toString x;
  #   in isFnKey keyToStr;

  # workspaceGenerator =
  #   { mod, preKey ? "", preCommand ? "move container to" }: x:
  #     let
  #       preCommand = lib.optionalString isMoveCommand "move container to";
  #       ws = builtins.toString (x + 1);
  #     in
  #       lib.nameValuePair "${mod}+${preKey + ws}" "${preCommand} workspace number ${ws}";

  # workspaceBindsymList =
  #   lib.genList
  #     (workspaceGenerator { inherit mod preKey; })
  #     mkWorkspaceNumber 1 10 { includeFnKeys = true; };

  # workspaceBindsyms = lib.listToAttrs workspaceBindsymList;
in
{
  "${mod}+1" = "workspace number 1";
  "${mod}+2" = "workspace number 2";
  "${mod}+3" = "workspace number 3";
  "${mod}+4" = "workspace number 4";
  "${mod}+5" = "workspace number 5";
  "${mod}+6" = "workspace number 6";
  "${mod}+7" = "workspace number 7";
  "${mod}+8" = "workspace number 8";
  "${mod}+9" = "workspace number 9";
  "${mod}+0" = "workspace number 10";
  "${mod}+F1" = "workspace number 11";
  "${mod}+F2" = "workspace number 12";
  "${mod}+F3" = "workspace number 13";
  "${mod}+F4" = "workspace number 14";
  "${mod}+F5" = "workspace number 15";
  "${mod}+F6" = "workspace number 16";
  "${mod}+F7" = "workspace number 17";
  "${mod}+F8" = "workspace number 18";
  "${mod}+F9" = "workspace number 19";
  "${mod}+F10" = "workspace number 20";
  "${mod}+F11" = "workspace number 21";
  "${mod}+F12" = "workspace number 22";

  "${mod}+Shift+1" = "move container to workspace number 1";
  "${mod}+Shift+2" = "move container to workspace number 2";
  "${mod}+Shift+3" = "move container to workspace number 3";
  "${mod}+Shift+4" = "move container to workspace number 4";
  "${mod}+Shift+5" = "move container to workspace number 5";
  "${mod}+Shift+6" = "move container to workspace number 6";
  "${mod}+Shift+7" = "move container to workspace number 7";
  "${mod}+Shift+8" = "move container to workspace number 8";
  "${mod}+Shift+9" = "move container to workspace number 9";
  "${mod}+Shift+0" = "move container to workspace number 10";
  "${mod}+Shift+F1" = "move container to workspace number 11";
  "${mod}+Shift+F2" = "move container to workspace number 12";
  "${mod}+Shift+F3" = "move container to workspace number 13";
  "${mod}+Shift+F4" = "move container to workspace number 14";
  "${mod}+Shift+F5" = "move container to workspace number 15";
  "${mod}+Shift+F6" = "move container to workspace number 16";
  "${mod}+Shift+F7" = "move container to workspace number 17";
  "${mod}+Shift+F8" = "move container to workspace number 18";
  "${mod}+Shift+F9" = "move container to workspace number 19";
  "${mod}+Shift+F10" = "move container to workspace number 20";
  "${mod}+Shift+F11" = "move container to workspace number 21";
  "${mod}+Shift+F12" = "move container to workspace number 22";

  # Shortcuts for easier navigation between workspaces
  "${mod}+Control+Left" = "workspace prev";
  "${mod}+Control+Right" = "workspace next";
  "${mod}+Tab" = "workspace back_and_forth";
}
