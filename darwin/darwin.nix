{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./brew.nix
    ./system-defaults.nix
  ];
  
  # Network configuration
  networking = {
    # DNS servers (Cloudflare and Google)
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    
    # Network service names that should be in the list of known network services
    knownNetworkServices = [
      "Wi-Fi"
    ];
  };
  
  # Set system hostname (using both legacy and modern settings)
  networking.computerName = "ZoBookPro"; # Legacy setting
  networking.hostName = "ZoBookPro";     # Legacy setting
  
  # These are the newer nix-darwin hostname settings that should be used
  system.defaults.HostName = "ZoBookPro";       # What shows in sharing settings
  system.defaults.LocalHostName = "ZoBookPro";  # Bonjour hostname (no spaces)
  system.defaults.ComputerName = "ZoBookPro";   # User-friendly computer name
  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  users.users.alonzothomas.shell = pkgs.fish;

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    # System tools
    home-manager         # Home manager CLI
    
    # Terminal & CLI
    warp-terminal        # AI terminal
    _1password-cli       # 1Password CLI
    
    # Network utilities
    ngrok                # Tunnel local servers
    transmission_4       # Torrent client
    
    # Commented out for reference
    # zed-editor         # Zed editor
    # teams              # Microsoft Teams
    # _1password-gui     # 1Password GUI (using Homebrew cask instead)
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/Developer/personal/my-nix";
  services = {
    # skhd = {
    #   enable = true;
    #   skhdConfig = (builtins.readFile ../hm/dotfiles/skhd/skhdrc);
    # };
    # yabai = {
    #   enable = true;
    #   # package = "/usr/local/bin/yabai";
    #   enableScriptingAddition = true;
    #   extraConfig = (builtins.readFile ../hm/dotfiles/yabai/yabairc);
    # };
  };

  # Nix configuration
  services.nix-daemon.enable = true;  # Auto upgrade nix package and run daemon
  
  nix = {
    package = pkgs.nixVersions.latest;  # Use the latest Nix version
    
    # Set NIX_PATH for legacy tools
    nixPath = { nixpkgs = "${inputs.nixpkgs}"; };
    
    # Nix settings
    settings = {
      # Enable useful experimental features
      "extra-experimental-features" = [
        "nix-command"
        "flakes"
      ];
      
      # Number of cores to use for building
      cores = 8;
      
      # Automatic garbage collection
      auto-optimise-store = true;          # Deduplication
      
      # Trusted users (can use remote builders and other restricted operations)
      trusted-users = [ "root" "alonzothomas" ];
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      interval = { 
        Weekday = 0;                       # Run on Sunday
        Hour = 2;                          # At 2AM
        Minute = 0;
      };
      options = "--delete-older-than 30d"; # Keep the last 30 days
    };
    
    # Additional options
    extraOptions = ''
      # Distributed build support
      builders = @/etc/nix/machines
      
      # Use up to 16GB of RAM for building
      max-jobs = auto
      cores = 0
    '';
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh.enable = true; # default shell on catalina
    fish.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system = {
    activationScripts.postActivation.text = ''
      # Set the default shell as fish for the user. MacOS doesn't do this like nixOS does
      sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish alonzothomas
    '';
  };

  # System-wide fonts
  fonts.packages = with pkgs; [
    # Monospace/coding fonts
    fira-code                  # Popular coding font with ligatures
    fira-mono                  # Monospace version of Fira
    input-fonts                # Highly customizable coding font
    monaspace                  # GitHub's modern monospace font family
    
    # Nerd fonts (with icons)
    nerd-fonts.fira-mono       # Fira Mono with Nerd Font icons
    nerd-fonts.jetbrains-mono  # JetBrains Mono with Nerd Font icons
    
    # Special purpose fonts
    powerline-fonts            # Terminal fonts with powerline symbols
  ];
}
