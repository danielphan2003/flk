let
  l = nixpkgs.lib // builtins // inputs.cells.flk.library;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {
      extraModulesPath,
      pkgs,
      ...
    }: {
      name = "flk";

      imports = [
        std.std.devshellProfiles.default
        "${extraModulesPath}/git/hooks.nix"
      ];

      std.adr.enable = false;

      std.docs.enable = false;

      git.hooks = {
        enable = true;
        pre-commit.text = builtins.readFile ./devshells/pre-flight-check.sh;
      };

      packages = [
        # formatters
        nixpkgs.alejandra
        nixpkgs.shfmt
        nixpkgs.nodePackages.prettier
        nixpkgs.stylua
        nixpkgs.fd
      ];

      commands = with l.categories; [
        (formatters nixpkgs.treefmt)
        (formatters nixpkgs.editorconfig-checker)
        (legal nixpkgs.reuse)
        (devos nixpkgs.age-plugin-yubikey)
        (devos inputs.agenix.packages.default)
        (devos (inputs.nixos-generators.defaultPackage.overrideAttrs (_: {
          patches = [./devshells/nixos-generators/148.patch];
        })))
        (devos inputs.colmena.defaultPackage)
        # (devos inputs.deploy.defaultPackage)
        (utils {
          name = "evalnix";
          help = "Check Nix parsing";
          command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
        })
        (docs nixpkgs.mdbook)
        (utils cell.packages.flkup)
        (utils cell.packages.repl)
      ];

      env = [
        (let
          searchPathVar = "NIXOS_GENERATORS_FORMAT_SEARCH_PATH";
        in {
          name = searchPathVar;

          # prepend our formats directory to the nixos-generate search path
          eval = ''
            ''${${searchPathVar}:+''${${searchPathVar}}:}${toString ./devshells/nixos-generators/formats}
          '';
        })
      ];
    };
  }
