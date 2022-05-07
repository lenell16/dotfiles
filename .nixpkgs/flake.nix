{
  description = "test";
  inputs = {
    # All packages should follow latest nixpkgs/nur
    unstable.url = "github:nixos/nixpkgs/master";
    # Nix-Darwin
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "unstable";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    # Neovim Nightly
    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
  };
   outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: {
    darwinConfigurations."alonzothomas-laptop" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./modules/mac.nix
        home-manager.darwinModule
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.alonzothomas = {
              imports = [
                ./modules/home.nix
              ];
            };
          };
        }
        ({ config, pkgs, lib, ... }: {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowInsecure = true;
              input-fonts.acceptLicense = true;
            };
            overlays = with inputs; [
              neovim-overlay.overlay
            ];
          };
        })
      ];
    };
  };
}