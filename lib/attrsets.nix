{lib}: let
  evalSuiteImports = tree: overrides: path: let
    f = import path;
    filterArgs = n: v: !(lib.functionArgs f)."${n}" or true;
    args = lib.filterAttrs filterArgs (overrides // {suites = tree;});
    attrs = f args;
    values = lib.collect builtins.isPath attrs;
  in
    values
    ++ builtins.foldl'
    (sum: x: sum ++ evalSuiteImports tree overrides x)
    []
    (attrs.imports or []);
in {
  inherit evalSuiteImports;

  mkSuite = suite: lib.flatten (lib.collect (x: builtins.isPath x || builtins.isList x) suite);

  importSuites = dirPath: overrides: let
    tree = lib.flattenTree (lib.rakeLeaves dirPath);
  in
    lib.mapAttrs
    (n: evalSuiteImports tree overrides)
    tree;
}
