{ lib }:

{ paths, persistPath }:
let inherit (lib) listToAttrs forEach nameValuePair; in
listToAttrs
  (forEach
    paths
    (path: nameValuePair "${path}" { source = "${persistPath}/etc/${path}"; }))