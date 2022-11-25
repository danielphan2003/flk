let
  l = builtins // inputs.nixlib.lib // inputs.flake-utils-plus.lib // cell.library;
  inherit (l) from;
in {
  __inputs__ = from ./library/inputs.nix;

  from = file:
    import file {
      lib = l;
      inherit inputs;
    };

  attrsets = from ./library/attrsets.nix;

  categories = from ./library/categories.nix;

  generators = from ./library/generators.nix;

  importers = from ./library/importers.nix;

  modules = from ./library/modules.nix;

  nixos-lib = from ./library/nixos-lib;

  sources = from ./library/sources.nix;

  strings = from ./library/strings.nix;

  inherit
    (l.attrsets)
    attrsToCamelCase
    expandAttrs
    expandAttrsToList
    filterChannels
    flattenTreeCamelCase
    mergeOn
    mkChannels
    mkSuite
    ;

  inherit
    (l.generators)
    mkNixosConfigurations
    ;

  inherit
    (l.importers)
    flattenTree'
    flattenTreeAny
    flattenTreeWithPath
    evalSuiteImports
    # importModules
    
    importSuites
    ;

  inherit
    (l.modules)
    flattenConfigs
    ;

  inherit
    (l.nixos-lib)
    hyprland
    i3wm
    ;

  inherit
    (l.sources)
    getFiles
    getNixFiles
    getPatchFiles
    ;

  inherit
    (l.strings)
    concatComma
    concatMapNewline
    concatNewline
    nameToCamelCase
    ;
}
