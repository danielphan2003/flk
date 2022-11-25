{
  lib,
  inputs,
}: let
  l = lib;
  inherit
    (l)
    collect
    concatStringsSep
    drop
    filterAttrs
    flatten
    flattenTree'
    flip
    foldl'
    head
    isAttrs
    isList
    listToAttrs
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mergeAny
    nameToCamelCase
    nameValuePair
    recursiveUpdate
    splitString
    ;
in rec {
  # Little hack, we make sure that `legacyPackages` contains `nix` to make sure that we are dealing with nixpkgs.
  # For some odd reason `devshell` contains `legacyPackages` out put as well
  filterChannels = filterAttrs (_: value: value ? legacyPackages && value.legacyPackages.x86_64-linux ? nix);
  mkChannels = inputs:
    mapAttrs (name: input: {inherit input;}) (filterChannels inputs);

  mergeOn = args:
    args
    // {
      __functor = flip mergeAny;
    };

  mkSuite = suite: lib.flatten (lib.collect (x: builtins.isPath x || builtins.isList x) suite);

  flattenTreeCamelCase = attrs: let
    flatAttrs = flattenTree' (x: !isAttrs x) attrs;
  in
    mapAttrs' (n: v: nameValuePair (nameToCamelCase n) v) flatAttrs;

  expandAttrsToList = mapAttrsToList (path: value: let
    keys = splitString "." path;
  in {
    name = head keys;
    value =
      if head keys != path
      then
        expandAttrsToList {
          "${concatStringsSep "." (drop 1 keys)}" = value;
        }
      else value;
  });

  expandAttrs = attrs:
    foldl'
    (sum: x:
      recursiveUpdate sum {
        "${x.name}" =
          if isList x.value
          then listToAttrs x.value
          else x.value;
      })
    {}
    (expandAttrsToList attrs);

  attrsToCamelCase = mapAttrs (_: hostCfg: let
    flatCamelCfg = flattenTreeCamelCase hostCfg;
  in
    expandAttrs flatCamelCfg);
}
