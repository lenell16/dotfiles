{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    cleanup = "zap";
    taps = [
      "koekeishiya/formulae"
      "homebrew/cask-drivers"
    ];
    brews = [
      "skhd"
    ];
    casks = [
			"elmedia-player"
			# "arc" (not in brew)
			# "lens"
			# "mailspring"
			# "quetbrowser"
			# "replay" (not in brew)
			# "scriptkit" (not in brew)
			# "vimac" (not in brew)
			# "visly" (not in brew)
			# firefoo (not in brew)
			# FruityUi (not in brew)
			# hide my bar (not in brew)
			# httpie ui (not in brew)
			# warp" (not in brew)
      "altserver"
      "appzapper"
      "docker"
      "dropbox"
      "expressvpn"
      "fantastical"
      "firefox"
      "google-chrome"
      "hazel"
      "marta"
      "omnidisksweeper"
      "raycast"
      "soundsource"
      "streamlink-twitch-gui"
      "transmission"
      "vmware-horizon-client"
      "zoom"
      "zsa-wally"
      # "brave-browser"
      # "contexts"
      # "daisydisk"
      # "firecamp"
      # "firefox-developer-edition"
      # "fork"
      # "framer-x"
      # "gitfox"
      # "goneovim"
      # "google-chrome-canary"
      # "insomnia-designer"
      # "insomnia"
      # "itch"
      # "java"
      # "kap"
      # "kindle"
      # "loopback"
      # "nova"
      # "pastebot"
      # "pixelsnap
      # "postgres"
      # "prisma-studio"
      # "protopie"
      # "robo-3t"
      # "runjs"
      # "screens-connect"
      # "screens"
      # "sizzy"
      # "slack"
      # "soda-player"
      # "spotify"
      # "steam"
      # "sublime-merge"
      # "tableplus"
      # "the-unarchiver"
      # "transmit"
      # "vlc"
      # "webstorm"
      # "wormhole"
    ];
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
}