{
  lib,
  inputs,
}: let
  l = lib;

  inherit
    (l)
    collect
    evalSuiteImports
    filterAttrs
    flatten
    flattenTree
    foldl'
    functionArgs
    isPath
    mapAttrs
    mapAttrsToList
    removeAttrs
    rakeLeaves
    ;
in rec {
  flattenTreeWithPath =
    /*
    *
    Synopsis: flattenTree _pred_ _tree_
    Flattens a _tree_ of the shape that satisfy _pred_.
    Output Format:
    An attrset with names in the spirit of the Reverse DNS Notation form
    that fully preserve information about grouping from nesting.
    Example input:
    ```
    {
    a = {
    b = {
    c = <any>;
    };
    };
    }
    ```
    Example output:
    ```
    {
    "a.b.c" = <any>;
    }
    ```
    *
    */
    pred: tree: let
      op = sum: path: val: let
        pathStr = builtins.concatStringsSep "." path; # dot-based reverse DNS notation
      in
        if pred path val
        then
          # builtins.trace "${toString val} is a path"
          (sum
            // {
              "${pathStr}" = val;
            })
        else if builtins.isAttrs val
        then
          # builtins.trace "${builtins.toJSON val} is an attrset"
          # recurse into that attribute set
          (recurse sum path val)
        else
          # ignore that value
          # builtins.trace "${toString path} is something else"
          sum;

      recurse = sum: path: val:
        builtins.foldl'
        (sum: key: op sum (path ++ [key]) val.${key})
        sum
        (builtins.attrNames val);
    in
      recurse {} [] tree;

  flattenTree' = pred: flattenTreeWithPath (_: pred);

  flattenTreeAny = flattenTree' (_: true);

  evalSuiteImports = attrs: path: let
    suiteFunc = import path;

    # check if an argument is required within a function
    isRequired = f: n: !(functionArgs f)."${n}" or true;

    # filter required arguments from a function
    filterArgs = f: filterAttrs (n: _: isRequired f n);

    suite = suiteFunc (filterArgs suiteFunc attrs);

    lhs = collect isPath suite;

    rhs =
      foldl'
      (sum: x: sum ++ evalSuiteImports attrs x)
      []
      (suite.imports or []);
  in
    lhs ++ rhs;

  # TODO: infinite recursion when used
  # importModules = {inputs, ...}@attrs:
  #   let
  #     # inputs' = flattenTree inputs;

  #     toDefaultImports = input: imports: let
  #       input' = flattenTree inputs."${input}";
  #       defaultImport =
  #         if input' ? "nixosModules.default"
  #         then "default"
  #         else input;
  #     in
  #       if imports == [] then [defaultImport] else imports;

  #     toModules = input:
  #       let
  #         input' = flattenTree inputs."${input}";
  #       in map (x: input'."nixosModules.${x}");

  #     attrs' = mapAttrs toDefaultImports (removeAttrs attrs ["inputs"]);
  #   in
  #   foldl' (sum: x: sum ++ x) [] (mapAttrsToList toModules attrs');

  importSuites = dir: attrs: let
    tree = flattenTree (rakeLeaves dir);

    attrs' = attrs // {suites = tree;};
  in
    mapAttrs (_: evalSuiteImports attrs') tree;
}
