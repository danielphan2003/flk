{lib}: let
  inherit
    (lib)
    mapAttrsToList
    range
    concatComma
    concatMapNewline
    concatNewline
    ;
in rec {
  mapEnvStr = attrs: concatNewline (mapAttrsToList (name: value: "${name}=${toString value}") attrs);

  applyWorkspaceBinds = f: let
    numberBinds = map (x: {
      key = x;
      args = [x];
    }) (range 1 9);

    specialNumberBind = [
      {
        key = 0;
        args = [10];
      }
    ];

    functionBinds = map (x: {
      key = "F${toString x}";
      args = [(x + 10)];
    }) (range 1 12);
  in
    concatMapNewline f (numberBinds ++ specialNumberBind ++ functionBinds);

  rule = rules: attrs: let
    args =
      if attrs ? title
      then "title:${attrs.title}"
      else attrs.class;
  in
    concatMapNewline (rule': concatComma ["windowrule=${rule'}" args]) rules;

  floatWith = rules: rule (["float"] ++ rules);

  float = floatWith [];

  bind = mod: key: dispatcher: params:
    "bind=" + concatComma [mod key dispatcher params] + "\n";

  exec = args: "exec=${args}";

  exec-once = args: "exec-once=${args}";

  section = section: {extraConfig ? "", ...} @ attrs: let
    attrs' = builtins.removeAttrs attrs ["extraConfig"];
  in ''
    ${section} {
      ${mapEnvStr attrs'}
      ${extraConfig}
    }
  '';

  animation = name: speed: curve: style:
    "animation=" + concatComma [name 1 speed curve style] + "\n";

  defaultAnimation = name: speed:
    animation name speed "default" "";

  monitor = name: res: offset: scale:
    "monitor=" + concatComma [name res offset scale] + "\n";

  workspace = name: number:
    "workspace=" + concatComma [name number] + "\n";
}
