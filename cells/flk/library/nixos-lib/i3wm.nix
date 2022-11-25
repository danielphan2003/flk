{lib}: let
  inherit
    (lib)
    concatStringsSep
    ;
in rec {
  rule = command: criteria: {
    command = command;
    criteria = criteria;
  };

  floatingNoBorder = rule "floating enable, border none";

  assign = n: id: {"${builtins.toString n}" = [id];};

  colorRule = background: border: childBorder: indicator: text: {
    background = background;
    border = border;
    childBorder = childBorder;
    indicator = indicator;
    text = text;
  };

  colorSetStr = {
    border,
    background,
    text,
    indicator,
    childBorder,
  } @ colors:
    concatStringsSep " " (builtins.attrValues colors);
}
