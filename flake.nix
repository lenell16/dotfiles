{
  description = "test";
  inputs = {
    nixpkgs-deprecated-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
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
      inputs.utils.follows = "flake-utils";
    };
    # Neovim Nightly
    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    unison = {
      url = "github:ceedubs/unison-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
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
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;


      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowUnsupportedSystem = true;
          allowUnfree = true;
          allowBroken = false;
          allowInsecure = true;
          input-fonts.acceptLicense = true;
        };
        overlays = attrValues self.overlays ++ [
          inputs.neovim-overlay.overlay
          inputs.unison.overlay
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          (final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              idris2;
          }))
          # (final: _: {
          #   # TODO: Remove when `stack` builds again on `nixpkgs-unstable`
          #   inherit (final.pkgs-master) stack;
          # })
        ];
      };

      # homeManagerStateVersion = "22.05";
      homeManagerStateVersion = "22.11";

      primaryUserInfo = {
        username = "alonzothomas";
        fullName = "Alonzo Thomas";
        email = "lenell16@gmail.com";
        nixConfigDirectory = "/Users/malo/.config/nixpkgs";
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
        alonzo-intel = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };

      };

      # Non-system outputs --------------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable-darwin = _: prev: {
          pkgs-stable-darwin = import inputs.nixpkgs-stable-darwin {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-deprecated-darwin = _: prev: {
          pkgs-deprecated-darwin = import inputs.nixpkgs-deprecated-darwin {
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

        # Modules I've created
        # programs-nix-index = import ./modules/darwin/programs/nix-index.nix;
        # security-pam = import ./modules/darwin/security/pam.nix;
        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # My configurations
        alonzo-config = import ./hm;
        # malo-config-files = import ./home/config-files.nix;
        # malo-fish = import ./home/fish.nix;
        # malo-git = import ./home/git.nix;
        # malo-git-aliases = import ./home/git-aliases.nix;
        # malo-gh-aliases = import ./home/gh-aliases.nix;
        # malo-kitty = import ./home/kitty.nix;
        # malo-neovim = import ./home/neovim.nix;
        # malo-packages = import ./home/packages.nix;
        # malo-starship = import ./home/starship.nix;
        # malo-starship-symbols = import ./home/starship-symbols.nix;

        # # Modules I've created
        # programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
        # programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;
        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser {
              inherit lib;
            }).options.users.primaryUser;
        };
      };
      # }}}

      # Add re-export `nixpkgs` packages with overlays.
      # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = with self.overlays; [
          pkgs-master
          pkgs-stable-darwin
          pkgs-deprecated-darwin
        ];
      };
    });
}
