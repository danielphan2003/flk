{
  self,
  inputs,
  ...
}: let
  inherit (inputs) digga nixos nixos-hardware;
in {
  hostDefaults = {
    system = "x86_64-linux";
    channelName = "nixos";
    imports = [(digga.lib.importExportableModules ./modules)];
    modules = with inputs; [
      agenix.nixosModules.age
      digga.nixosModules.bootstrapIso
      home.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      hyprland.nixosModules.default
      nix-gaming.nixosModules.pipewireLowLatency
      peerix.nixosModules.peerix
      qnr.nixosModules.local-registry
      # stylix.nixosModules.stylix
      ({
        nixpkgsModulesPath,
        pkgs,
        ...
      }: {
        system.stateVersion = "22.05";
      })
    ];
  };

  imports = [(digga.lib.importHosts ./hosts)];

  hosts = {
    bootstrap = {
      tests = [];
    };
    NixOS = {
      tests = [];
    };
    pik2 = {
      system = "aarch64-linux";
      modules = with inputs; [
        nixos-hardware.nixosModules.raspberry-pi-4
        ({nixpkgsModulesPath, ...}: {
          imports = ["${nixpkgsModulesPath}/services/hardware/argonone.nix"];
          services.dnscrypt-proxy2.settings = {
            tls_cipher_suite = [52392 49199];
            max_clients = 10000;
          };
        })
      ];
      tests = [];
    };
    themachine = {
      modules = [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        {
          services.dnscrypt-proxy2.settings = {
            max_clients = 10000;
          };
        }
      ];
      tests = [];
    };
    rog-bootstrap = {
      modules = [
        nixos-hardware.nixosModules.asus-rog-strix-g733qs
        nixos-hardware.nixosModules.common-gpu-nvidia-disable
      ];
    };
  };

  importables = let
    hostConfigs = nixos.lib.importTOML ./hosts/hosts.toml;

    profiles =
      digga.lib.rakeLeaves ./profiles
      // {
        users = digga.lib.rakeLeaves ../home/users;
      };

    suites = self.lib.importSuites ./suites {
      inherit (self) lib;
      inherit profiles;
    };
  in {
    inherit profiles suites;

    hostConfigs =
      nixos.lib.recursiveUpdate
      hostConfigs
      {
        hosts =
          nixos.lib.mapAttrs
          (hostName: module: {
            tailnet_domain = "${hostName}.${hostConfigs.tailscale.tailnet_alias}";
            type = hostConfigs.hosts."${hostName}".type or "permanant";
          })
          hostConfigs.hosts;
      };
  };
}
