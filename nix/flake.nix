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
          inputs.neovim-overlay.overlay
          inputs.unison.overlay
        ];
      };

      # homeManagerStateVersion = "22.05";
      homeManagerStateVersion = "22.11";

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

      };

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

        yabai = _: super: {
          yabai =
            let
              replace = {
                "aarch64-darwin" = "--replace '-arch x86_64' ''";
                "x86_64-darwin" = "--replace '-arch arm64e' '' --replace '-arch arm64' ''";
              }.${super.pkgs.stdenv.system};
            in
            super.yabai.overrideAttrs (
              o: rec {
                version = "4.0.0";
                src = super.fetchFromGitHub {
                  owner = "koekeishiya";
                  repo = "yabai";
                  rev = "v${version}";
                  sha256 = "sha256-rllgvj9JxyYar/DTtMn5QNeBTdGkfwqDr7WT3MvHBGI=";
                };
                postPatch = ''
                  substituteInPlace makefile ${replace};
                '';
                buildPhase = ''
                  PATH=/usr/bin:/bin /usr/bin/make install
                '';
              }
            );
        };
      };

      darwinModules = {
        # My configurations
        alonzo-bootstrap = import ./darwin/bootstrap.nix;
        alonzo-preferences = import ./darwin/preferences.nix;
        alonzo-core = import ./darwin/core.nix;
        alonzo-postgres = import ./darwin/postgres.nix;
        alonzo-homebrew = import ./darwin/brew.nix;

        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # My configurations
        alonzo-dotfiles = import ./hm/dotfiles;
        alonzo-vscode = import ./hm/vscode.nix;
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
