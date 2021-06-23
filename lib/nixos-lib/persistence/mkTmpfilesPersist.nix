{ lib }:

{ paths, persistPath }:
let inherit (lib) forEach; in
forEach
  paths
  (path: "L ${path} - - - - ${persistPath}${path}")