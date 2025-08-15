{
  description = "Configuration NixOS avec Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "git+https://gitlab.com/jeremiealcaraz/nyanvim.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    rec {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./host/nixos/configuration.nix

            # module Home-Manager
            home-manager.nixosModules.home-manager

            # glue pour charger la config user
            {
              home-manager.useGlobalPkgs   = true;
              home-manager.useUserPackages = true;
              # Ajoutez cette ligne pour passer inputs
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.users.jeremie = import ./home-manager/home.nix;

            }
          ];
        };
      };
    };
}
