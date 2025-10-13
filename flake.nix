{
  description = "Configuration NixOS avec Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "git+https://gitlab.com/jeremiealcaraz/nyanvim.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , disko
    , ...
    } @ inputs:
    let
      mkFormatter = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "fmt";
          runtimeInputs = [ pkgs.nixpkgs-fmt pkgs.findutils ];
          text = builtins.readFile ./scripts/fmt.sh;
        };
      baseModules = [
        ({ pkgs, ... }: {
          programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [
              stdenv.cc.cc
              zlib
              curl
              openssl
            ];
          };

          users.users.jeremie.linger = true;
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.jeremie = import ./home-manager/home.nix;
        }
      ];

      mkHost = hostConfig: extraModules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ hostConfig ] ++ baseModules ++ extraModules;
        };
    in
    rec {
      nixosConfigurations = {
        nixos = mkHost ./host/nixos/configuration.nix [ ];
        proxmox = mkHost ./host/proxmox/configuration.nix [ disko.nixosModules.disko ];
      };

      formatter = {
        x86_64-linux = mkFormatter "x86_64-linux";
        aarch64-darwin = mkFormatter "aarch64-darwin";
      };
    };
}
