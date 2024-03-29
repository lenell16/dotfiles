{
  description = "test";
  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Nix-Darwin
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # Neovim Nightly
    # neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # Unison
    unison.url = "github:ceedubs/unison-nix";
    # Utils
    flake-utils.url = "github:numtide/flake-utils";

    rose-pine-kitty = {
      type = "github";
      owner = "rose-pine";
      repo = "kitty";
      flake = false;
    };
    gitalias = {
      type = "github";
      owner = "GitAlias";
      repo = "gitalias";
      flake = false;
    };

  };
  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues;


      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowUnsupportedSystem = true;
          allowUnfree = true;
          allowBroken = true;
          allowInsecure = true;
          input-fonts.acceptLicense = true;
        };
        overlays = attrValues self.overlays ++ [
          # inputs.neovim-overlay.overlay
          inputs.unison.overlay
        ];
      };

      homeManagerStateVersion = "23.11";

      primaryUserInfo = {
        username = "alonzothomas";
        fullName = "Alonzo Thomas";
        email = "lenell16@gmail.com";
        nixConfigDirectory = "/Users/alonzothomas/Developer/dotfiles/nix";
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
            nixpkgs = nixpkgsConfig;
            # Hack to support legacy worklows that use `<nixpkgs>` etc.
            # nix.nixPath = { nixpkgs = "${primaryUser.nixConfigDirectory}/nixpkgs.nix"; };
            nix.nixPath = { nixpkgs = "${inputs.nixpkgs-unstable}"; };
            # `home-manager` config
            users.users.${primaryUser.username}.home = "/Users/${primaryUser.username}";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${primaryUser.username} = {
              imports = attrValues self.homeManagerModules;
              home.stateVersion = homeManagerStateVersion;
              home.user-info = config.users.primaryUser;
            };
            # Add a registry entry for this flake
            nix.registry.my.flake = self;
          }
        )
      ];

    in
    {
      # My `nix-darwin` configs
      darwinConfigurations = rec {
        ZoBookPro = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
              networking.computerName = "Alonzo Macbook";
              networking.hostName = "ZoBookPro";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
            }
          ];
        };
        ZoBookOld = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
            }
          ];
        };

      };

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
      };

      darwinModules = {
        # My configurations
        alonzo-bootstrap = import ./darwin/bootstrap.nix;
        alonzo-preferences = import ./darwin/preferences.nix;
        alonzo-core = import ./darwin/core.nix;
        alonzo-homebrew = import ./darwin/brew.nix;

        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # My configurations
        alonzo-dotfiles = import ./hm/dotfiles;
        alonzo-editors = import ./hm/editors.nix;
        alonzo-git = import ./hm/git.nix;
        alonzo-kitty = import ./hm/kitty.nix;
        alonzo-neovim = import ./hm/neovim.nix;
        alonzo-packages = import ./hm/packages.nix;
        alonzo-fish = import ./hm/fish.nix;
        alonzo-programs = import ./hm/programs.nix;

        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser {
              inherit lib;
            }).options.users.primaryUser;
        };
      };
    };
}
