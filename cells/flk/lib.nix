{
  inputs,
  cell,
}:
let
  l = inputs.l // cell.lib;
  inherit (inputs) nixlib;
  inherit (l) from;
in {
  __inputs__ = from ./lib/inputs.nix;

  from = file: import file { lib = l; inherit inputs; };

  attrsets = from ./lib/attrsets.nix;

  categories = from ./lib/categories.nix;

  generators = from ./lib/generators.nix;

  importers = from ./lib/importers.nix;

  l = builtins // nixlib.lib;

  modules = from ./lib/modules.nix;

  nixos-lib = from ./lib/nixos-lib;

  sources = from ./lib/sources.nix;

  strings = from ./lib/strings.nix;

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
