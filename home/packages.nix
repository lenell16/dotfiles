{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  # Pinned nixpkgs for packages with cache issues
  pkgs-pinned = import inputs.nixpkgs-pinned {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
in
{
  home.packages = with pkgs; [
    # Nix tools
    any-nix-shell # Use nix shell with fish
    nixd # Nix language server
    nixpkgs-fmt # Nix formatter
    nixfmt-rfc-style # RFC 166 compliant Nix formatter

    # Cloud & DevOps
    atlas # Database schema migration tool
    (azure-cli.withExtensions [
      azure-cli-extensions.application-insights
      azure-cli-extensions.azure-devops
    ]) # Azure command line
    pkgs-pinned.azure-functions-core-tools # Azure Functions development (pinned for cache hit)
    infisical # Secrets management

    # Development tools
    bun # JavaScript runtime
    grpc-tools # gRPC Node.js tools (includes protoc + plugins)
    jira-cli-go # Jira CLI
    jdk21 # OpenJDK 21
    node-pre-gyp # Binary deployment tool for C++ addons
    pm2 # Node.js process manager
    pyright # Python type checker
    turbo # Monorepo tool
    uv # Python package installer
    jetbrains.datagrip # Database IDE
    postgresql_14 # PostgreSQL client tools (psql, pg_dump, etc.)

    # System utilities
    curl # Data transfer tool
    fd # Alternative to find
    ripgrep # Fast grep replacement
    raycast # App launcher
    starship # Cross-shell prompt (used by fish integration)

    # Media
    iina # Media player
    yt-dlp # YouTube downloader



    # Commented out packages (kept for reference)
    # asdf-vm
    # ghostty

    # Other commented packages below are alternatives or tools you might want in the future
    # google-cloud-sdk.withExtraComponents ([
    #   google-cloud-sdk.components.gke-gcloud-auth-plugin
    # ])
    # crystal         # Programming language
    # gobang          # Database tool
    # ant             # Build tool
    # black           # Python formatter
    # cargo           # Rust package manager
    # cloudflared     # Cloudflare tunnels
    # cocoapods       # iOS dependency manager
    deno # JavaScript runtime
    # ffmpeg          # Media processing
    # fx              # JSON processor
    # gitflow         # Git workflow
    # gitkraken       # Git client
    # google-cloud-sql-proxy # GCP SQL proxy
    # gradle          # Build tool
    # httpie          # HTTP client
    # kubectx         # Kubernetes context switcher
    # lucky-cli       # Crystal web framework
    # miller          # CSV processor
    # mongodb         # NoSQL database
    pnpm # Package manager (nodePackages.* removed from nixpkgs)
    nodejs_20 # Node.js v20 LTS with npm
    # overmind        # Process manager
    pkg-config # Build tooling for native addons
    cairo # Graphics library required by node-canvas
    pango # Text layout library
    pixman # Pixel manipulation library
    libpng # PNG support
    glib # GNOME base library (pango dep)
    fontconfig # Font configuration discovery
    libjpeg # JPEG support
    giflib # GIF support
    # devenv          # Development environments
    # ltex-ls         # Grammar checker
    # marksman        # Markdown language server
    # procs           # Process viewer
    # rustc           # Rust compiler
    # rustfmt         # Rust formatter
    # sd              # Sed alternative
    # selene          # Lua linter
    # shellcheck      # Shell script linter
    # shfmt           # Shell formatter
    # streamlink      # Stream downloader
    # stylua          # Lua formatter
    # tree            # Directory listing tool
    # unison-ucm      # File sync
    # vault           # Secret management
    # viu             # Terminal image viewer
    # watchman        # File watcher
    # wget            # Network downloader
    # xplr            # File explorer
  ];
}
