{ config, pkgs, ... }:

{
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
    };
  };

  # nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.input-fonts.acceptLicense = true;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
  users.users.alonzothomas.shell = pkgs.fish;

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      powerline-fonts
      fira-code
      fira-mono
      input-fonts
      (nerdfonts.override { fonts = [ "FiraMono" ]; })
    ];
  };


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
      # "4k-stogram"
      # "alfred"
      # "altserver"
      # "amethyst"
      # "appzapper"
      # "brave-browser"
      # "contexts"
      # "daisydisk"
      "docker"
      # "drama"
      "dropbox"
      "expressvpn"
      "fantastical"
      # "firecamp"
      # "firefox"
      # "firefox-developer-edition"
      # "fork"
      # "framer-x"
      # "gitfox"
      "gitkraken"
      # "goneovim"
      "google-chrome"
      # "google-chrome-canary"
      "hazel"
      "iina"
      # "insomnia"
      # "insomnia-designer"
      # "itch"
      "iterm2"
      # "java"
      # "kap"
      # "kindle"
      # "loopback"
      # "marta"
      # "notion"
      # "nova"
      # "now"
      # "omnidisksweeper"
      # "pastebot"
      # "pixelsnap"
      # "pocket-casts"
      # "postgres"
      "postman"
      # "prisma-studio"
      # "protopie"
      # "raindropio"
      "raycast"
      # "robo-3t"
      # "runjs"
      # "screens"
      # "screens-connect"
      # "sizzy"
      # "slack"
      "soda-player"
      "soundsource"
      # "spotify"
      # "steam"
      "streamlink-twitch-gui"
      # "sublime-merge"
      # "tableplus"
      # "the-unarchiver"
      "transmission"
      # "transmit"
      # "vlc"
      # "vmware-horizon-client"
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
  };
}
