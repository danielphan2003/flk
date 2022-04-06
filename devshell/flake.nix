{
  description = "Flk development shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.blank.url = "github:divnix/blank";
  inputs.devshell.url = "github:numtide/devshell?ref=refs/pull/169/head";
  inputs.treefmt.url = "github:numtide/treefmt";
  inputs.alejandra.url = "github:kamadorueda/alejandra";
  inputs.alejandra.inputs.treefmt.follows = "blank";
  inputs.deploy.url = "github:serokell/deploy-rs";
  inputs.agenix.url = github:yaxitech/ragenix;
  inputs.nixos-generators.url = "github:nix-community/nixos-generators";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.std.url = "github:divnix/std";
  outputs = inputs:
    inputs.flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (
      system: let
        inherit
          (inputs.std.deSystemize system inputs)
          std
          deploy
          devshell
          nixpkgs
          agenix
          nixos-generators
          alejandra
          treefmt
          ;

        cmdWithCategory = category: attrs: attrs // {inherit category;};
        pkgWithCategory = category: package: cmdWithCategory category {inherit package;};
        withCategory = category: {
          cmd = cmdWithCategory category;
          pkg = pkgWithCategory category;
        };
        formatters = withCategory "formatters";
        docs = withCategory "docs";
        devos = withCategory "devos";
        legal = withCategory "legal";
        utils = withCategory "utils";
      in {
        devShells.default = devshell.legacyPackages.mkShell (
          {
            extraModulesPath,
            pkgs,
            ...
          }: {
            name = "Flk";

            packages = [
              # formatters
              alejandra.defaultPackage
              nixpkgs.legacyPackages.shfmt
              nixpkgs.legacyPackages.nodePackages.prettier
              nixpkgs.legacyPackages.stylua
              nixpkgs.legacyPackages.fd
            ];

            commands = [
              (formatters.pkg nixpkgs.legacyPackages.treefmt)
              (formatters.pkg nixpkgs.legacyPackages.editorconfig-checker)
              (legal.pkg nixpkgs.legacyPackages.reuse)
              (devos.pkg nixpkgs.legacyPackages.nix)
              (devos.pkg nixpkgs.legacyPackages.age-plugin-yubikey)
              (devos.pkg agenix.defaultPackage)
              (devos.pkg nixos-generators.defaultPackage)
              (devos.pkg deploy.defaultPackage)
              (devos.pkg nixpkgs.legacyPackages.cachix)
              (utils.cmd {
                name = "evalnix";
                help = "Check Nix parsing";
                command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
              })
              (devos.cmd {
                name = "repl";
                help = "Run Nix Repl";
                command = let
                  repl = pkgs.callPackage ./repl {};
                in "${repl}/bin/repl";
              })
              (devos.pkg (pkgs.callPackage ./flkup.nix {}))
              (docs.pkg nixpkgs.legacyPackages.mdbook)
            ];

            imports = [
              "${extraModulesPath}/git/hooks.nix"
            ];

            git.hooks = {
              enable = true;
              pre-commit.text = builtins.readFile ./pre-commit.sh;
            };
          }
        );
      }
    );
}
