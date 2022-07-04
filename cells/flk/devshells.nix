{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs;
  inherit (inputs.std) std;
in
  l.mapAttrs (_: std.lib.mkShell) {
    default = {
      extraModulesPath,
      pkgs,
      ...
    }: {
      name = "flk";

      std.docs.enable = false;

      git.hooks = {
        enable = true;
        pre-commit.text = builtins.readFile ./devshells/pre-flight-check.sh;
      };

      imports = [
        std.devshellProfiles.default
        "${extraModulesPath}/git/hooks.nix"
      ];

      packages = [
        # formatters
        nixpkgs.alejandra
        nixpkgs.shfmt
        nixpkgs.nodePackages.prettier
        nixpkgs.stylua
        nixpkgs.fd
      ];

      commands = with cell.categories; [
        (formatters nixpkgs.treefmt)
        (formatters nixpkgs.editorconfig-checker)
        (legal nixpkgs.reuse)
        (devos nixpkgs.age-plugin-yubikey)
        (devos inputs.agenix.defaultPackage)
        (devos inputs.nixos-generators.defaultPackage)
        (devos inputs.deploy.defaultPackage)
        (utils {
          name = "evalnix";
          help = "Check Nix parsing";
          command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
        })
        (docs nixpkgs.mdbook)
        (utils cell.flkup.default)
      ];
    };
  }
