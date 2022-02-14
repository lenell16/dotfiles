{ config, pkgs, ... }:

let
	stable = import <stable> {
		config = {
			allowUnfree = true;
			allowInsecure = true;
		};
	};
in

{
  imports = [
    ./dotfiles
    ./programs
  ];

  programs.home-manager.enable = true;
  home = {
    sessionVariables= {
      DOTBARE_DIR = "$HOME/dotfiles";
      DOTBARE_TREE = "$HOME";
			NIXPKGS_ALLOW_INSECURE = 1;
			NIXPKGS_ALLOW_UNFREE = 1;
			TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
			EDITOR = "nvim";
			VISUAL = "nvim";
		};
    packages = with pkgs; [
      any-nix-shell
      amp
      stable.blender
      cocoapods
      stable.crystal
      curl
      deno
      fd
      ffmpeg
      fx
      gitflow
      gh
      google-cloud-sdk
      httpie
      kubectx
      stable.lucky-cli
      micro
      miller
      stable.mongodb
      ngrok
      neovim-nightly
      nixpkgs-fmt
      nodejs
      nodePackages.pnpm
      openconnect
      overmind
      procs
      ripgrep
      sd
      streamlink
      tree
      vault
      wally-cli
      watchman
      wget
			xplr
      yarn
      youtube-dl
			yt-dlp
    ];
  };

  programs = {
		# atuin = {
		# 	enable = true;
		# };

    bat.enable = true;

    bottom.enable = true;

		broot = {
			enable = true;
			enableFishIntegration = true;
		};

    exa = {
      enable = true;
      enableAliases = true;
    };

    fish = {
      enable = true;
      shellInit = ''
        any-nix-shell fish --info-right | source
      '';
      shellAliases = {
        dotbare = "$HOME/.dotbare/dotbare";
      };
			# interactiveShellInit = ''
			# 	${pkgs.atuin}/bin/atuin init fish | source
			# '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      userName = "lenell16";
      userEmail = "lenell16@gmail.com";
			includes = [
				{
						path = ./dotfiles/git/gitalias/gitalias.txt;
					}
			];
    };

    go.enable = true;

		# helix = {
		# 	enable = true;
		# };

    jq.enable = true;

		kakoune = {
			enable = true;
		};

		kitty = {
			enable = true;
			settings = {
				macos_option_as_alt = true;
			};
      extraConfig = builtins.readFile ./dotfiles/kitty/extraConfig.conf;
		};

    lazygit.enable = true;

    mpv.enable = true;

    nnn.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        cmd_duration.disabled = true;
        gcloud.disabled = true;
      };
    };

    tmux.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
