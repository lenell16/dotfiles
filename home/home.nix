{ inputs, config, pkgs, lib, ... }:
{

  imports = [
    ./packages.nix
    ./aliases.nix
  ];

  home = {
    stateVersion = "24.05"; # Please read the comment before changing.

    # Environment variables
    sessionVariables = {
      # Editor settings
      EDITOR = "nvim";
      VISUAL = "nvim";
      
      # Pager settings
      PAGER = "bat";
      LESS = "-R";
      
      # Configure bat (better cat)
      BAT_THEME = "OneHalfDark";
      BAT_STYLE = "header,grid";
      BAT_TABS = "2";
      BAT_DIFF_CONTEXT = "3";
      BAT_DIFF_NUMBERS = "true";
      BAT_DIFF_FILE_SIZE_THRESHOLD = "1M";
      
      # XDG data dirs (for shell integration)
      XDG_DATA_DIRS = "${config.home.profileDirectory}/share:${"\${GHOSTTY_SHELL_INTEGRATION_XDG_DIR:+\$GHOSTTY_SHELL_INTEGRATION_XDG_DIR:}"}$XDG_DATA_DIRS";
    };

    # Files to create in home directory
    file = {
      # Suppress the login message on macOS terminal
      ".hushlogin".text = "";
    };
  };

  programs = {
    # Development environments
    direnv = {
      enable = true;
      # enableFishIntegration is true by default and set in the module
      nix-direnv.enable = true;
    };
    
    # GitHub CLI
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    # Terminal utilities
    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
        style = "header,grid";
      };
    };

    bottom = {
      enable = true;   # System monitor (like htop)
    };

    broot = {
      enable = true;   # Directory navigator
      enableFishIntegration = true;
    };

    eza = {
      enable = true;   # Modern replacement for ls
      enableFishIntegration = true;
    };

    jq = {
      enable = true;   # JSON processor
    };

    fzf = {
      enable = true;   # Fuzzy finder
      enableFishIntegration = true;
      defaultOptions = ["--height 40%" "--layout=reverse" "--border"];
    };

    # Shell enhancements
    starship = {
      enable = true;   # Customizable prompt
      enableFishIntegration = true;
      settings = {
        cmd_duration.disabled = true;
        gcloud.disabled = true;
      };
    };
    
    # File managers
    nnn = {
      enable = true;   # Terminal file manager
      bookmarks = {
        d = "~/Documents";
        D = "~/Downloads";
        p = "~/Developer/personal";
        w = "~/Developer/work";
      };
    };

    # Text editors
    helix = {
      enable = true;   # Modern editor
      settings = {
        theme = "tokyonight_storm";
      };
    };

    # Terminal multiplexer
    tmux = {
      enable = true;   # Terminal session manager
      clock24 = true;
      historyLimit = 10000;
      terminal = "screen-256color";
    };

    # Git configuration
    git = {
      enable = true;
      # userName = "lenell16";
      # userEmail = "lenell16@gmail.com";
      
      # Include external aliases
      includes = [
        {
          path = "${inputs.gitalias}/gitalias.txt";
        }
      ];
      
      # Git configuration
      extraConfig = {
        push = {
          autoSetupRemote = true;  # Auto set upstream on push
        };
        init = {
          defaultBranch = "main";  # Default branch name
        };
        pull = {
          rebase = false;         # Merge by default on pull
        };
        fetch = {
          prune = true;           # Remove remote branches that no longer exist
        };
      };
    };

    # Git UI tools
    gitui = {
      enable = true;              # Terminal UI for Git
    };

    lazygit = {
      enable = true;              # Interactive Git terminal UI
    };

    # Fish shell configuration
    fish = {
      enable = true;

      # Commands to run when starting an interactive shell
      interactiveShellInit = ''
        # Multiple ways to ensure no greeting
        set -U fish_greeting
        set -g fish_greeting ""
        
        # Initialize Homebrew
        eval "$(/opt/homebrew/bin/brew shellenv)"
        
        # Add Homebrew Node.js to PATH
        fish_add_path /opt/homebrew/opt/node@20/bin
        
        # Set fish colors to match your terminal theme
        set -g fish_color_command blue
        set -g fish_color_param cyan
        set -g fish_color_error red
        set -g fish_color_normal normal
      '';

      # Custom fish functions
      functions = {
        # This explicitly overrides the greeting function
        fish_greeting = ""; 
        
        # Show system info
        sysinfo = ''
          echo "System Information"
          echo "=================="
          echo "OS: $(uname -srm)"
          echo "Host: $(hostname)"
          echo "Uptime: $(uptime | sed 's/.*up \\([^,]*\\), .*/\\1/')"
          echo "Shell: $SHELL"
          echo "Terminal: $TERM"
          echo "Nix Version: $(nix --version)"
        '';
      };
      
      # Aliases are now managed in aliases.nix
      
      # Commands to run when starting any shell
      shellInit = ''
        # Ghostty terminal integration
        if test -n "$GHOSTTY_SHELL_INTEGRATION_XDG_DIR"
            source $GHOSTTY_SHELL_INTEGRATION_XDG_DIR/fish/vendor_conf.d/ghostty-shell-integration.fish
        end
        
        # Nix shell integration
        any-nix-shell fish --info-right | source
      '';
    };

    # Directory navigation enhancement
    zoxide = {
      enable = true;              # Smart cd command
      enableFishIntegration = true;
      options = [ "--cmd j" ];    # Use 'j' as the command
    };

    # Text editor
    neovim = {
      enable = true;              # Neovim editor
      package = pkgs.neovim-unwrapped;
      defaultEditor = true;
      viAlias = true;             # Use 'vi' command for neovim
      vimAlias = true;            # Use 'vim' command for neovim
    };
  };
}
