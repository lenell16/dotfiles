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
      "ankitpokhrel/jira-cli"
      "danvergara/tools"
      "nikitabobko/tap"
      "supabase/tap"
      "opencode-ai/tap"
      "FelixKratz/formulae"
    ];

    brews = [
      # CLI tools
      # "azure-cli"            # Azure CLI
      # "gh"                  # GitHub CLI
      "ankitpokhrel/jira-cli/jira-cli" # Jira CLI
      # "node@20"             # Node.js version 20 (now managed via Nix)
      "openssl@3" # SSL library
      "mas" # Mac App Store CLI
      # "opencode" # OpenCode AI

      # Database
      # "pgvector" # Vector extension for PostgreSQL
      # "postgresql@14" # PostgreSQL database
      "supabase/tap/supabase" # Supabase CLI

      # Window Management
      "FelixKratz/formulae/borders" # JankyBorders - window borders for tiling WM

      # Graphics libraries (required by other tools and node-canvas)
      "cairo" # 2D graphics library (for node-canvas)
      "freetype" # Font rendering library (for node-canvas)
      "giflib" # GIF image manipulation library
      "jpeg" # JPEG image manipulation library
      "librsvg" # SVG rendering library
      "pango" # Text layout and rendering library (for node-canvas)
      "pixman" # Pixel manipulation library (for node-canvas)
      "pkgconf" # Package compiler and linker metadata toolkit
      "poppler" # PDF rendering library

      # Currently not used but commented for reference
      # "dblab"             # Database client
    ];

    casks = [
      # Security & Password Management
      # "1password"                  # Password manager
      "1kc-razer" # Razer keyboard configuration

      # System Utilities
      "appzapper" # App uninstaller
      "balenaetcher" # USB image writer
      # "block-goose"                # Ad blocker
      "marta" # File manager
      "soundsource" # Audio control
      "workman" # Keyboard layout
      "yaak" # Terminal
      "conductor" # System management tool

      # Terminal & Development
      "ghostty" # Terminal emulator
      "gitkraken" # Git client
      "lm-studio" # Local LLM development platform
      # "ollama"                     # Local LLM runner
      # "visual-studio-code@insiders" # Code editor
      "visual-studio-code"
      "warp" # Modern terminal emulator
      # "cursor"                     # AI-powered code editor
      "zed" # Modern code editor

      # Browsers & Internet
      "arc" # Browser
      "google-chrome" # Browser

      # Productivity
      "chatgpt" # AI assistant
      "chatwise" # Chat client
      "claude" # AI assistant
      "adobe-acrobat-reader" # PDF reader
      "fantastical" # Calendar app
      "kap" # Screen recorder
      "repo-prompt" # Git repository prompt utility
      "slack" # Team communication
      "zoom" # Video conferencing

      # Media & Entertainment
      "nvidia-geforce-now" # Game streaming
      "calibre" # E-book management
      "ea" # Electronic Arts game launcher
      "steam" # Game platform
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
      "Duplicate File Finder" = 1032755628;
      "Elmedia Video Player" = 1044549675;
      "GarageBand" = 682658836;
      "Gemini 2" = 1090488118;
      "Is This Seat Taken" = 6747814605;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Prime Video" = 545519333;
      "Reeder" = 6475002485;
      "Steam Link" = 1246969117;
      "Surfshark" = 1437809329;
      "TestFlight" = 899247664;
      "iMovie" = 408981434;
    };
  };
}
