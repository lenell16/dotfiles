{ lib, ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "homebrew/services"
      "danvergara/tools"
      "homebrew/cask-versions"
      "nikitabobko/tap"
      "supabase/tap"
    ];

    brews = [
      # "skhd"
      # "dblab"
      "node@20"
      "openssl@3"
      "pgvector"
      "postgresql@14"
      "supabase"
    ];

    casks = [
      "1password"
      "aerospace"
      "appzapper"
      "arc"
      "chatgpt"
      "fantastical"
      "gitkraken"
      "ghostty"
      "google-chrome"
      "kap"
      "marta"
      "nvidia-geforce-now"
      "pgadmin4"
      "raycast"
      # "runjs"
      "slack"
      "soundsource"
      # "steam"
      "visual-studio-code@insiders"
      "workman"
      "yaak"
      # "altserver"
      # "android-studio"
      # "docker"
      # "dropbox"
      # "expressvpn"
      # "hazel"
      # "omnidisksweeper"
      # "prisma-studio"
      # "steam"
      # "streamlink-twitch-gui"
      # "tableplus"
      # "transmission"
      # "zoom"
      # "bartender"
      # "brave-browser"
      # "firefox"
      # "hammerspoon"
      # "karabiner-elements"
      # "obsidian"
      # "wezterm"
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
      # "lens"
      # "loopback"
      # "mailspring"
      # "nova"
      # "pastebot"
      # "pixelsnap
      # "protopie"
      # "quetbrowser"
      # "replay" (not in brew)
      # "robo-3t"
      # "runjs"
      # "screens-connect"
      # "screens"
      # "scriptkit" (not in brew)
      # "sizzy"
      # "soda-player"
      # "spotify"
      # "sublime-merge"
      # "the-unarchiver"
      # "transmit"
      # "vimac" (not in brew)
      # "visly" (not in brew)
      # "vlc"
      # "webstorm"
      # "wormhole"
      # firefoo (not in brew)
      # FruityUi (not in brew)
      # hide my bar (not in brew)
      # httpie ui (not in brew)
    ];

    masApps = {
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
      # "Xcode" = 497799835;
      # "AdGuard for Safari" = 1440147259;
      # "QuickShade" = 931571202;
      # "Surfshark" = 1437809329;
    };
  };
}
