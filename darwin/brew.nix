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
      # CLI tools
      "gh"                  # GitHub CLI
      "node@20"             # Node.js 20
      "openssl@3"           # SSL library
      
      # Database
      "pgvector"            # Vector extension for PostgreSQL
      "postgresql@14"       # PostgreSQL database
      "supabase"            # Supabase CLI
      
      # Graphics libraries (required by other tools)
      "giflib"              # GIF image manipulation library
      "jpeg"                # JPEG image manipulation library
      "librsvg"             # SVG rendering library
      "pkgconf"             # Package compiler and linker metadata toolkit
      "poppler"             # PDF rendering library
      
      # Currently not used but commented for reference
      # "skhd"              # Simple hotkey daemon
      # "dblab"             # Database client
    ];

    casks = [
      # Security & Password Management
      "1password"                  # Password manager
      
      # System Utilities
      "aerospace"                  # Window manager
      "appzapper"                  # App uninstaller
      "marta"                      # File manager
      "raycast"                    # App launcher
      "soundsource"                # Audio control
      "workman"                    # Keyboard layout
      "yaak"                       # Terminal
      
      # Terminal & Development
      "ghostty"                    # Terminal emulator
      "gitkraken"                  # Git client
      "pgadmin4"                   # PostgreSQL admin tool
      "visual-studio-code@insiders" # Code editor
      
      # Browsers & Internet
      "arc"                        # Browser
      "google-chrome"              # Browser
      
      # Productivity
      "chatgpt"                    # AI assistant
      "fantastical"                # Calendar app
      "kap"                        # Screen recorder
      "slack"                      # Team communication
      
      # Media & Entertainment
      "nvidia-geforce-now"         # Game streaming
      
      # Currently not used but kept for reference
      # "runjs"                    # JavaScript playground
      # "steam"                    # Game platform
      # "altserver"                # iOS sideloading
      # "android-studio"           # Android development
      # "docker"                   # Containerization
      # "dropbox"                  # Cloud storage
      # "expressvpn"               # VPN client
      # "hazel"                    # File automation
      # "omnidisksweeper"          # Disk space analyzer
      # "prisma-studio"            # Database GUI
      # "streamlink-twitch-gui"    # Twitch client
      # "tableplus"                # Database GUI
      # "transmission"             # Torrent client
      # "zoom"                     # Video conferencing
      # "bartender"                # Menu bar organizer
      # "brave-browser"            # Browser
      # "firefox"                  # Browser
      # "hammerspoon"              # Automation tool
      # "karabiner-elements"       # Keyboard customizer
      # "obsidian"                 # Note-taking
      # "wezterm"                  # Terminal
      # "contexts"                 # Window switcher
      # "daisydisk"                # Disk space visualizer
      # "firecamp"                 # API testing
      # "firefox-developer-edition" # Browser dev edition
      # "fork"                     # Git client
    ];

    masApps = {
      # Currently all App Store apps are commented out
      # Uncomment any app you want to install via nix-darwin
      
      # Development
      # "Xcode" = 497799835;
      
      # Productivity
      # "Dashlane" = 517914548;            # Password manager
      # "Pastory" = 1560463189;            # Clipboard manager
      # "Pocket" = 568494494;              # Read-it-later app
      # "SnippetsLab" = 1006087419;        # Code snippets manager
      
      # Utilities
      # "AdGuard for Safari" = 1440147259; # Ad blocker
      # "Black Out" = 1319884285;          # Screen dimmer
      # "ColorSlurp" = 1287239339;         # Color picker
      # "FireStream" = 1005325119;         # Network testing
      # "QuickShade" = 931571202;          # Screen dimmer
      # "Surfshark" = 1437809329;          # VPN client
      
      # Media & Social
      # "Reeder" = 1529448980;             # RSS reader
      # "Shazam" = 897118787;              # Music recognition
      # "Tweetbot" = 1384080005;           # Twitter client
      # "Twitter" = 1482454543;            # Twitter official app
    };
  };
}
