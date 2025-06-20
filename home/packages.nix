{ inputs, config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Nix tools
    any-nix-shell    # Use nix shell with fish
    nixd             # Nix language server
    nixpkgs-fmt      # Nix formatter
    
    # Cloud & DevOps
    azure-cli                  # Azure command line
    azure-functions-core-tools # Azure Functions development
    infisical                  # Secrets management
    
    # Development tools
    bun              # JavaScript runtime
    protobuf         # Protocol buffers
    pyright          # Python type checker
    turbo            # Monorepo tool
    uv               # Python package installer
    jetbrains.datagrip # Database IDE
    
    # System utilities
    curl             # Data transfer tool
    fd               # Alternative to find
    ripgrep          # Fast grep replacement
    raycast          # App launcher
    podman           # Container management tool
    docker-client    # Docker CLI client
    
    # Media
    iina             # Media player
    yt-dlp           # YouTube downloader
    
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
    # corepack_21     # JavaScript package manager tool
    # deno            # JavaScript runtime
    # ffmpeg          # Media processing
    # fx              # JSON processor
    # gitflow         # Git workflow
    # gitkraken       # Git client
    # google-cloud-sql-proxy # GCP SQL proxy
    # gradle          # Build tool
    # httpie          # HTTP client
    # kubectx         # Kubernetes context switcher
    # lucky-cli       # Crystal web framework
    # maven           # Build tool
    # miller          # CSV processor
    # mongodb         # NoSQL database
    # nodejs_20       # Node.js (managed via Homebrew)
    # nodePackages.eslint_d      # Fast ESLint
    # nodePackages.fixjson       # JSON fixer
    # nodePackages.pnpm          # Package manager
    # nodePackages.prettier      # Code formatter
    # nodePackages.typescript    # TypeScript
    # nodePackages.zx            # JavaScript shell scripts
    # overmind        # Process manager
    # pkg-config      # Package compiler tool
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
    # yarn            # Package manager
  ];
}