let
  src = ../..;
in
  import
  (
    let
      lock = builtins.fromJSON (builtins.readFile "${src}/flake.lock");
    in
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
  )
  {inherit src;}
