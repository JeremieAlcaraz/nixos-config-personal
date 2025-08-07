{
  description = "Configuration NixOS avec Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    rec {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./nixos/configuration.nix

            # module Home-Manager
            home-manager.nixosModules.home-manager

            # glue pour charger la config user
            {
              home-manager.useGlobalPkgs   = true;
              home-manager.useUserPackages = true;

              home-manager.users.jeremie = {
                imports = [ ./home-manager/home.nix ];
              };
            }
          ];
        };
      };
    };
}
