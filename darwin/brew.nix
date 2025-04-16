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
      "danvergara/tools"
      "nikitabobko/tap"
      "supabase/tap"
    ];

    brews = [
      # CLI tools
      # "gh"                  # GitHub CLI
      "node@20"             # Node.js 20
      "openssl@3"           # SSL library
      "mas"                 # Mac App Store CLI
      
      # Database
      "pgvector"            # Vector extension for PostgreSQL
      "postgresql@14"       # PostgreSQL database
      "supabase/tap/supabase"            # Supabase CLI
      
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
      "1kc-razer"                  # Razer keyboard configuration
      
      # System Utilities
      "appzapper"                  # App uninstaller
      "balenaetcher"               # USB image writer
      "block-goose"                # Ad blocker
      "marta"                      # File manager
      "soundsource"                # Audio control
      "workman"                    # Keyboard layout
      "yaak"                       # Terminal
      
      # Terminal & Development
      "ghostty"                    # Terminal emulator
      "gitkraken"                  # Git client
      "visual-studio-code@insiders" # Code editor
      "warp"                       # Modern terminal emulator
      "cursor" 
      
      # Browsers & Internet
      "arc"                        # Browser
      "google-chrome"              # Browser
      
      # Productivity
      "chatgpt"                    # AI assistant
      "chatwise"                   # Chat client
      "claude"                     # AI assistant
      "adobe-acrobat-reader"       # PDF reader
      "fantastical"                # Calendar app
      "kap"                        # Screen recorder
      "repo-prompt"                # Git repository prompt utility
      "slack"                      # Team communication
      "zoom"                       # Video conferencing
      
      # Media & Entertainment
      "nvidia-geforce-now"         # Game streaming
      "calibre"                    # E-book management
      "ea"                         # Electronic Arts game launcher
      "steam"                      # Game platform
      # "mpv"                        # Video player (added as a replacement for nix version)
      
      # Currently not used but kept for reference
      # "runjs"                    # JavaScript playground
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
      # Currently installed apps
      "1Password for Safari" = 1569813296;
      "Balatro" = 6502451661;
      "Cornsweeper" = 1600387153;
      "Duplicate File Finder" = 1032755628;
      "Elmedia Video Player" = 1044549675;
      "Gemini 2" = 1090488118;
      "Grindstone" = 1476307705;
      "LocalSend" = 1661733229;
      "Prime Video" = 545519333;
      "RCT Classic+" = 6702028686;
      "Steam Link" = 1246969117;
      "Surfshark" = 1437809329;
      "TestFlight" = 899247664;

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
      
      # Media & Social
      # "Reeder" = 1529448980;             # RSS reader
      # "Shazam" = 897118787;              # Music recognition
      # "Tweetbot" = 1384080005;           # Twitter client
      # "Twitter" = 1482454543;            # Twitter official app
    };
  };
}
