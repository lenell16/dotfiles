{
  description = "Alonzo's darwin system";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Nix-Darwin
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Neovim Nightly
    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Unison
    # unison.url = "github:ceedubs/unison-nix";
    # Utils
    flake-utils.url = "github:numtide/flake-utils";

    # rose-pine-kitty = {
    #   type = "github";
    #   owner = "rose-pine";
    #   repo = "kitty";
    #   flake = false;
    # };
    gitalias = {
      type = "github";
      owner = "GitAlias";
      repo = "gitalias";
      flake = false;
    };
  };

  outputs =
    { self
    , nix-darwin
    , flake-utils
    , home-manager
    , neovim-overlay
    , ...
    } @ inputs:
    let
      system = "aarch64-darwin";
      overlays = [
        inputs.neovim-overlay.overlays.default
      ];
    in
    {
      darwinConfigurations = {
        "ZoBookPro" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./darwin/darwin.nix
            home-manager.darwinModules.home-manager
            {
              # nixpkgs.overlays = overlays;
              home-manager = {
                users.alonzothomas = import ./home/home.nix;
                extraSpecialArgs = { inherit inputs system; };
                useGlobalPkgs = true;
                useUserPackages = true;
              };
              users.users.alonzothomas.home = "/Users/alonzothomas";
              nixpkgs.config = {
                allowUnsupportedSystem = true;
                allowUnfree = true;
                allowBroken = true;
                allowInsecure = true;
                input-fonts.acceptLicense = true;
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
