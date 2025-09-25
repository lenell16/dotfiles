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
    # 1Password Shell Plugins
    onepassword-shell-plugins.url = "github:1Password/shell-plugins";

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
    {
      self,
      nix-darwin,
      flake-utils,
      home-manager,
      neovim-overlay,
      ...
    }@inputs:
    let
      system = "aarch64-darwin";
      username = "alonzothomas";
      homeDirectory = "/Users/alonzothomas";
      
      # CENTRALIZED: Define nixpkgs config once
      nixpkgsConfig = {
        allowUnsupportedSystem = true;
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = true;
        input-fonts.acceptLicense = true;
      };
      
      # CENTRALIZED: Define overlays once
      overlays = [
        inputs.neovim-overlay.overlays.default
      ];
      
      # Helper to create nixpkgs with consistent config
      mkPkgs = system: import inputs.nixpkgs {
        inherit system overlays;
        config = nixpkgsConfig;
      };
      
      # Helper for system-specific outputs (2025 best practice)
      forAllSystems =
        f:
        inputs.nixpkgs.lib.genAttrs [ system ] (
          system:
          f {
            pkgs = mkPkgs system;
          }
        );
    in
    {
      # Formatter output for `nix fmt`
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);

      # Development shell for `nix develop`
      devShells = forAllSystems (
        { pkgs }:
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              nixfmt-rfc-style
              nix-tree
              nix-info
            ];
            shellHook = ''
              echo "🚀 Dotfiles development environment"
              echo "Available commands:"
              echo "  nix fmt     - Format all Nix files"
              echo "  nix-tree    - Explore dependency tree"
              echo "  nix-info -m - System info"
            '';
          };
        }
      );

      darwinConfigurations = {
        "ZoBookPro" = nix-darwin.lib.darwinSystem {
          inherit system;
          # Use centralized nixpkgs
          pkgs = mkPkgs system;
          modules = [
            ./darwin/darwin.nix
            home-manager.darwinModules.home-manager
            {
              # Use centralized config
              nixpkgs = {
                inherit overlays;
                config = nixpkgsConfig;
              };
              
              home-manager = {
                users.alonzothomas = import ./home/home.nix;
                extraSpecialArgs = { inherit inputs system; };
                useGlobalPkgs = true;  # This ensures HM uses the same pkgs
                useUserPackages = true;
                backupFileExtension = "backup";
              };
              users.users.alonzothomas.home = "/Users/alonzothomas";
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
      homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          # Use the same centralized nixpkgs
          pkgs = mkPkgs system;
          modules = [
            ./home/home.nix
            {
              home = {
                inherit username homeDirectory;
              };
            }
          ];
          extraSpecialArgs = { inherit inputs system; };
        };
      };
    };
}
