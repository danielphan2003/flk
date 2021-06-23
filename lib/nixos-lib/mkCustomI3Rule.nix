{ lib }:
rec {
  rule = command: criteria: { command = command; criteria = criteria; };
  floatingNoBorder = criteria: rule "floating enable, border none" criteria;
  assign = n: id: { "${builtins.toString n}" = [ id ]; };
  colorRule = background: border: childBorder: indicator: text: {
    background = background;
    border = border;
    childBorder = childBorder;
    indicator = indicator;
    text = text;
  };
  colorSetStr = c:
    lib.concatStringsSep " " [
      c.border
      c.background
      c.text
      c.indicator
      c.childBorder
    ];
}
