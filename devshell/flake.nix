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

        pkgWithCategory = category: package: {inherit package category;};
        formatters = pkgWithCategory "formatters";
        docs = pkgWithCategory "docs";
        devos = pkgWithCategory "devos";
        legal = pkgWithCategory "legal";
        utils = pkgWithCategory "utils";
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
            ];

            commands = [
              (formatters nixpkgs.legacyPackages.treefmt)
              (formatters nixpkgs.legacyPackages.editorconfig-checker)
              (legal nixpkgs.legacyPackages.reuse)
              (devos nixpkgs.legacyPackages.nix)
              (devos nixpkgs.legacyPackages.age-plugin-yubikey)
              (devos agenix.defaultPackage)
              (devos nixos-generators.defaultPackage)
              (devos deploy.defaultPackage)
              (devos nixpkgs.legacyPackages.cachix)
              (utils {
                name = "evalnix";
                help = "Check Nix parsing";
                command = "${nixpkgs.legacyPackages.fd}/bin/fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
              })
              (docs nixpkgs.legacyPackages.mdbook)
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
