{ lib, config, ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
      extraFlags = [ "--force-cleanup" ];
    };

    taps = [
      "ahmedelgabri/tap"
      "atlassian/homebrew-acli"
      {
        name = "chmouel/lazyworktree";
        clone_target = "https://github.com/chmouel/lazyworktree";
      }
      "danvergara/tools"
      "nikitabobko/tap"
      "satococoa/tap"
      "supabase/tap"
      "FelixKratz/formulae"
    ];

    # Homebrew 6+ requires explicit trust for third-party taps (see docs.brew.sh/Tap-Trust).
    # nix-darwin does not yet expose `trusted` on tap/brew/cask entries; extraConfig appends to the Brewfile.
    extraConfig = ''
      tap "ahmedelgabri/tap", trusted: true
      tap "atlassian/homebrew-acli", trusted: true
      tap "chmouel/lazyworktree", trusted: true
      tap "danvergara/tools", trusted: true
      tap "nikitabobko/tap", trusted: true
      tap "satococoa/tap", trusted: true
      tap "supabase/tap", trusted: true
      tap "FelixKratz/formulae", trusted: true
      brew "ahmedelgabri/tap/git-wt", trusted: true
    '';

    brews = [
      # CLI tools
      # "ahmedelgabri/tap/git-wt" # Git worktree CLI
      # "satococoa/tap/git-worktreeinclude" # Include shared attributes across worktrees
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

      # "worktrunk" # Git worktree manager
      # "rtk" # CLI proxy to minimize LLM token consumption
    ];

    casks = [
      # Security & Password Management
      "1password-cli" # Official op binary (/opt/homebrew/bin/op); integrates with the desktop app
      "1kc-razer" # Razer keyboard configuration

      # System Utilities
      "balenaetcher" # USB image writer
      # "block-goose"                # Ad blocker
      "marta" # File manager
      "soundsource" # Audio control
      "workman" # Keyboard layout
      "yaak" # Terminal
      "conductor" # System management tool
      "thaw" # Menu bar manager (Thaw)

      # Terminal & Development
      "devtunnel" # Microsoft DevTunnel for secure tunneling
      "chmouel/lazyworktree/lazyworktree" # TUI for managing Git worktrees
      "ghostty" # Terminal emulator
      "orbstack" # Docker & Linux VM runtime
      "gitkraken" # Git client
      "gitkraken-cli" # Git CLI client
      "localcan" # Local development with public URLs and .local domains
      # "opencode-desktop" # OpenCode desktop application
      # "ollama"                     # Local LLM runner
      # "visual-studio-code@insiders" # Code editor
      "visual-studio-code"
      "warp" # Modern terminal emulator
      # "cursor"                     # AI-powered code editor
      "zed" # Modern code editor

      # Browsers & Internet
      # "arc" # Browser
      # "firefox" # Browser
      "google-chrome" # Browser

      # "zen" # Browser

      # Productivity
      "chatgpt" # AI assistant
      "chatwise" # Chat client
      # "claude" # AI assistant
      "adobe-acrobat-reader" # PDF reader
      # "fantastical" # Calendar app
      # "kap" # Screen recorder
      # "repo-prompt" # Git repository prompt utility
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

  # git-wt moved from tap ahmedelgabri/git-wt to ahmedelgabri/tap; a leftover tap or lock breaks upgrades.
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    hb_prefix="${config.homebrew.prefix}"
    hb_user="${config.homebrew.user}"
    if [ -x "$hb_prefix/bin/brew" ]; then
      if sudo --user="$hb_user" --set-home "$hb_prefix/bin/brew" tap 2>/dev/null | grep -qx 'ahmedelgabri/git-wt'; then
        echo "Removing stale Homebrew tap ahmedelgabri/git-wt (migrated to ahmedelgabri/tap)..."
        sudo --user="$hb_user" --set-home "$hb_prefix/bin/brew" untap ahmedelgabri/git-wt || true
      fi
      rm -f "$hb_prefix/var/homebrew/locks/git-wt.formula.lock" 2>/dev/null || true
    fi
  '';
}
