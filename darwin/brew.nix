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
      "ahmedelgabri/git-wt"
      "atlassian/homebrew-acli"
      {
        name = "chmouel/lazyworktree";
        clone_target = "https://github.com/chmouel/lazyworktree";
      }
      "danvergara/tools"
      "nikitabobko/tap"
      "supabase/tap"
      "FelixKratz/formulae"
    ];

    brews = [
      # CLI tools
      "ahmedelgabri/git-wt/git-wt" # Git worktree CLI
      "atlassian/homebrew-acli/acli" # Atlassian CLI
      "mole" # Mac cleaning and optimization tool
      # "node@20"             # Node.js version 20 (now managed via Nix)
      "openssl@3" # SSL library
      "mas" # Mac App Store CLI

      # Database
      "supabase/tap/supabase" # Supabase CLI

      # Window Management
      "FelixKratz/formulae/borders" # JankyBorders - window borders for tiling WM

      # Graphics libraries (required by other tools and node-canvas)
      "freetype" # Font rendering library (for node-canvas)
      "jpeg" # JPEG image manipulation library
      "librsvg" # SVG rendering library
      "pkgconf" # Package compiler and linker metadata toolkit
      "poppler" # PDF rendering library

      "worktrunk" # Git worktree manager
      "rtk" # CLI proxy to minimize LLM token consumption
    ];

    casks = [
      # Security & Password Management
      "1kc-razer" # Razer keyboard configuration

      # System Utilities
      "balenaetcher" # USB image writer
      # "block-goose"                # Ad blocker
      "marta" # File manager
      "soundsource" # Audio control
      "workman" # Keyboard layout
      "yaak" # Terminal
      "conductor" # System management tool

      # Terminal & Development
      "devtunnel" # Microsoft DevTunnel for secure tunneling
      "chmouel/lazyworktree/lazyworktree" # TUI for managing Git worktrees
      "ghostty" # Terminal emulator
      "orbstack" # Docker & Linux VM runtime
      "gitkraken" # Git client
      "gitkraken-cli" # Git CLI client
      "localcan" # Local development with public URLs and .local domains
      "lm-studio" # Local LLM development platform
      "opencode-desktop" # OpenCode desktop application
      # "ollama"                     # Local LLM runner
      # "visual-studio-code@insiders" # Code editor
      "visual-studio-code"
      "warp" # Modern terminal emulator
      # "cursor"                     # AI-powered code editor
      "zed" # Modern code editor

      # Browsers & Internet
      "arc" # Browser
      "firefox" # Browser
      "google-chrome" # Browser

      "zen" # Browser

      # Productivity
      "chatgpt" # AI assistant
      "chatwise" # Chat client
      # "claude" # AI assistant
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
      # "streamlink-twitch-gui"    # Twitch client
      # "tableplus"                # Database GUI
      # "hammerspoon"              # Automation tool
      # "karabiner-elements"       # Keyboard customizer
      # "obsidian"                 # Note-taking
    ];

    # masApps = {
    #   # Currently installed apps
    #   "1Password for Safari" = 1569813296;
    #   "Duplicate File Finder" = 1032755628;
    #   "Elmedia Video Player" = 1044549675;
    #   "Gemini 2" = 1090488118;
    #   "Hidden Bar" = 1452453066;
    #   "Is This Seat Taken" = 6747814605;
    #   "Reeder" = 6475002485;
    #   "Steam Link" = 1246969117;
    #   "Surfshark" = 1437809329;
    #   "TestFlight" = 899247664;
    # };
  };
}
