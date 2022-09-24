{
  inputs,
  cell,
}:
let
  l = builtins // nixlib.lib;
  inherit (inputs) home nixlib nixpkgs;
in {
  # default = 

  portable = home: username: configuration': let
    homeDirectoryPrefix =
      if nixpkgs.stdenv.hostPlatform.isDarwin
      then "/Users"
      else "/home";
    homeDirectory = "${homeDirectoryPrefix}/${username}";
    builder = import "${home}/modules/default.nix";
    configuration = {
      imports = [
        configuration'
        (
          if nixpkgs.stdenv.hostPlatform.isLinux
          then {targets.genericLinux.enable = true;}
          else {}
        )
        ({pkgs, ...}: {
          # _module.args.pkgsPath = pkgs.path;
          home = {inherit homeDirectory username;};
          home.stateVersion = l.mkDefault "22.11";
        })
      ];
    };
  in
    builder {
      inherit configuration;
      # default, override via nixpkgs.pkgs
      pkgs = nixpkgs;
    };
}