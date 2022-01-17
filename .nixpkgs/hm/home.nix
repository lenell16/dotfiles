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

  nixpkgs.config = {
		allowUnfree = true;
  	allowInsecure = true;
	};
  programs.home-manager.enable = true;
  home = {
    sessionVariables= {
      DOTBARE_DIR = "$HOME/dotfiles";
      DOTBARE_TREE = "$HOME";
			NIXPKGS_ALLOW_INSECURE = 1;
			NIXPKGS_ALLOW_UNFREE = 1;
			TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
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
      neovim
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
      yarn
      youtube-dl
			yt-dlp
    ];
  };

  programs = {
    bat.enable = true;

    bottom.enable = true;

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

    jq.enable = true;

		kitty = {
			enable = true;
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
