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
      bud.nixosModules.bud
      digga.nixosModules.bootstrapIso
      digga.nixosModules.nixConfig
      home.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      "${matrix-appservices}/nixos/modules/services/misc/matrix-appservices/default.nix"
      nix-gaming.nixosModule
      peerix.nixosModules.peerix
      qnr.nixosModules.local-registry
      ({
        latestModulesPath,
        pkgs,
        ...
      }: {
        imports = [
          "${latestModulesPath}/services/misc/matrix-conduit.nix"
          "${latestModulesPath}/services/web-servers/caddy/default.nix"
          "${latestModulesPath}/virtualisation/waydroid.nix"
        ];

        disabledModules = [
          "services/web-servers/caddy/default.nix"
          "virtualisation/waydroid.nix"
        ];
      })
    ];
  };

  imports = [(digga.lib.importHosts ./hosts)];

  hosts = with nixos-hardware.nixosModules; {
    bootstrap = {
      tests = [];
    };
    NixOS = {
      tests = [];
    };
    pik2 = {
      system = "aarch64-linux";
      modules = with inputs; [
        argonone-utils.nixosModules.argonone-i2c
        argonone-utils.nixosModules.argonone-power-button
        raspberry-pi-4
        {
          services.dnscrypt-proxy2.settings = {
            tls_cipher_suite = [52392 49199];
            max_clients = 10000;
          };
        }
      ];
      tests = [];
    };
    themachine = {
      modules = [
        common-cpu-amd
        common-gpu-amd
        common-pc-ssd
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
        asus-rog-strix-g733qs
        common-gpu-nvidia-disable
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
  in {
    inherit profiles;

    inherit
      (import ./suites {
        inherit (self) lib;
        inherit profiles;
      })
      suites
      ;

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
