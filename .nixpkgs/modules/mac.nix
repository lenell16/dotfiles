{ config, pkgs, lib, ... }: {

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
    };

		# skhd = {
		# 	enable = true;
		# 	skhdConfig = builtins.readFile ./hm/dotfiles/skhd/skhdrc;
		# };
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  users = {
    users.alonzothomas = {
      name = "alonzothomas";
      home = "/Users/alonzothomas";
      shell = pkgs.fish;
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      powerline-fonts
      fira-code
      fira-mono
      input-fonts
      (nerdfonts.override { fonts = [
				"FiraMono"
				"JetBrainsMono"
			]; })
    ];
  };

  homebrew = {
    enable = true;
    cleanup = "zap";
    taps = [
      "koekeishiya/formulae"
      "homebrew/cask-drivers"
			"unisonweb/unison"
    ];
    brews = [
      "skhd"
			"unison-language"
    ];
    casks = [
      # "4k-stogram"
      # "alfred"
      "altserver"
      # "amethyst"
      "appzapper"
			# "arc" (not in brew)
      # "brave-browser"
      # "contexts"
      # "daisydisk"
      "docker"
      # "drama"
      "dropbox"
			"elmedia-player"
      "expressvpn"
      "fantastical"
      # "firecamp"
			# firefoo (not in brew)
      "firefox"
      # "firefox-developer-edition"
      # "fork"
      # "framer-x"
			# FruityUi (not in brew)
      # "gitfox"
      # "gitkraken"
      # "goneovim"
      "google-chrome"
      # "google-chrome-canary"
      "hazel"
			# hide my bar (not in brew)
			# httpie ui (not in brew)
      "iina"
      # "insomnia"
      # "insomnia-designer"
			# "instabro" (not in brew)
      # "itch"
      # "iterm2"
      # "java"
      # "kap"
      # "kindle"
			# "scriptkit" (not in brew)
			# "lens"
      # "loopback"
			# "mailspring"
      "marta"
      # "notion"
      # "nova"
      "omnidisksweeper"
      # "pastebot"
      # "pixelsnap"
      # "pocket-casts"
      # "postgres"
      "postman"
      # "prisma-studio"
      # "protopie"
			# "quetbrowser"
      # "raindropio"
      "raycast"
			# "replay" (not in brew)
      # "robo-3t"
      # "runjs"
      # "screens"
      # "screens-connect"
      # "sizzy"
      # "slack"
      # "soda-player"
      "soundsource"
      # "spotify"
      # "steam"
      "streamlink-twitch-gui"
      # "sublime-merge"
      # "tableplus"
      # "the-unarchiver"
      "transmission"
      # "transmit"
			# "vimac" (not in brew)
			# "visly" (not in brew)
      # "vlc"
      "vmware-horizon-client"
			# warp" (not in brew)
      # "webstorm"
      # "wormhole"
      "zoom"
      "zsa-wally"
    ];
    extraConfig = ''
      brew "koekeishiya/formulae/yabai", args: ["HEAD"]
    '';
    # masApps = {
    #   "Black Out" = 1319884285;
    #   "ColorSlurp" = 1287239339;
    #   "Dashlane" = 517914548;
    #   "FireStream" = 1005325119;
    #   "Pastory" = 1560463189;
    #   "Pocket" = 568494494;
    #   "Reeder" = 1529448980;
    #   "Shazam" = 897118787;
    #   "SnippetsLab" = 1006087419;
    #   "Tweetbot" = 1384080005;
    #   "Twitter" = 1482454543;
    #   "Xcode" = 497799835;
    # };

  };

  system = {
    stateVersion = 4;
    defaults = {
      dock = {
        orientation = "right";
        autohide = true;
        mru-spaces = false;
      };
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
        _HIHideMenuBar = true;
      };
    };
    activationScripts.postActivation.text = ''
      # Set the default shell as fish for the user. MacOS doesn't do this like nixOS does
      sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish shauryasingh
    '';
  };

  environment.systemPackages = with pkgs; [
    # blender
    kitty
    mpv
    vscode
		gitkraken
		# iina
  ];
}
