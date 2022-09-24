{
  inputs,
  cell,
}: let
  l = builtins // nixlib.lib // cells.std.lib;
  inherit (inputs) self cells nixlib nixpkgs std;
  inherit (self) defaultSystem;
  inherit (cells) flk;
in {
  importHosts = {
    inputs,
    hostsFrom,
    cellBlocks ? [
      (std.functions "configurations")
      (std.functions "modules")
      (std.functions "profiles")
      (std.functions "suites")
    ]
  }: let
    f = std.grow {
      inherit cellBlocks;
      inputs = inputs // {Cells = cells;};
      cellsFrom = hostsFrom;
    };
  in
    f.${defaultSystem};

  importUsers = {
    inputs,
    usersFrom,
    cellBlocks ? [
      (std.functions "modules")
      (std.functions "profiles")
      (std.functions "suites")
    ]
  }: let
    users = l.attrNames (flk.lib.rakeLeaves usersFrom);
    eachUsers = users: f: let
      mapUserConfigs = user: let
        userPath = "${usersFrom}/${user}";
        userConfigs = (f userPath).${defaultSystem};
      in
        userConfigs;
    in
      l.genAttrs users mapUserConfigs;
  in
    eachUsers users (userPath: std.grow {
      inherit cellBlocks;
      inputs = inputs // {Cells = cells;};
      cellsFrom = userPath;
    });
}
