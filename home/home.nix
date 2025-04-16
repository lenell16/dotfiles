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
      
      # Podman configuration
      DOCKER_HOST = "unix:///var/folders/zy/gd7_972101sdqv5_625lgdmh0000gn/T/podman/podman-machine-default-api.sock";
      
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

    # Terminal emulator
    ghostty = {
      enable = false;  # Disabled due to build issues - using Homebrew version instead
      # settings = {
      #   shell = "fish";
      #   font-family = "JetBrainsMono Nerd Font";
      #   font-size = 12;
      #   background = "#1e1e2e";
      #   foreground = "#cdd6f4";
      #   cursor = "#f5e0dc";
      #   selection = "#585b70";
      #   color0 = "#45475a"; # black
      #   color1 = "#f38ba8"; # red
      #   color2 = "#a6e3a1"; # green
      #   color3 = "#f9e2af"; # yellow
      #   color4 = "#89b4fa"; # blue
      #   color5 = "#f5c2e7"; # magenta
      #   color6 = "#94e2d5"; # cyan
      #   color7 = "#bac2de"; # white
      #   color8 = "#585b70"; # bright black
      #   color9 = "#f38ba8"; # bright red
      #   color10 = "#a6e3a1"; # bright green
      #   color11 = "#f9e2af"; # bright yellow
      #   color12 = "#89b4fa"; # bright blue
      #   color13 = "#f5c2e7"; # bright magenta
      #   color14 = "#94e2d5"; # bright cyan
      #   color15 = "#a6adc8"; # bright white
      # };
    };

    # Git configuration
    git = {
      enable = true;
      # Global default configuration (work profile)
      userName = "Alonzo Thomas";
      userEmail = "alonzo.thomas@tribble.ai";
      
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
      
      # Git conditional includes for different profiles
      ignores = [];
      includes = [
        { path = "${inputs.gitalias}/gitalias.txt"; }
        { 
          condition = "gitdir:~/Developer/personal/";
          contents = {
            user = {
              name = "lenell16";
              email = "lenell16@gmail.com";
            };
          };
        }
        { 
          condition = "gitdir:~/Developer/tribble/";
          contents = {
            user = {
              name = "Alonzo Thomas";
              email = "alonzo.thomas@tribble.ai";
            };
          };
        }
      ];
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
        
        # Create directory and change to it
        mcd = ''
          if test (count $argv) -eq 1
            mkdir -p $argv[1] && cd $argv[1]
          else
            echo "Usage: mcd <directory>"
          end
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

    # Window Manager
    aerospace = {
      enable = true;
      userSettings = {
        # General settings
        start-at-login = false;
        after-login-command = [];
        after-startup-command = [];

        # Normalizations
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        # Layouts
        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        # Callbacks
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        # automatically-unhide-macos-hidden-apps = false; # Option not found in module schema

        # Key Mapping Preset
        key-mapping.preset = "qwerty";

        # Gaps
        gaps = {
          inner = {
            horizontal = 10;
            vertical = 10;
          };
          outer = {
            left = 10;
            bottom = 0;
            top = 0;
            right = 10;
          };
        };

        # Modes and Bindings
        mode = {
          main.binding = {
            "alt-slash" = "layout tiles horizontal vertical";
            "alt-comma" = "layout accordion horizontal vertical";
            "cmd-alt-left" = "focus left";
            "cmd-alt-down" = "focus down";
            "cmd-alt-up" = "focus up";
            "cmd-alt-right" = "focus right";
            "cmd-alt-shift-left" = "move left";
            "cmd-alt-shift-down" = "move down";
            "cmd-alt-shift-up" = "move up";
            "cmd-alt-shift-right" = "move right";
            "alt-shift-minus" = "resize smart -50";
            "alt-shift-equal" = "resize smart +50";
            "alt-1" = "workspace 1";
            "alt-2" = "workspace 2";
            "alt-3" = "workspace 3";
            "alt-4" = "workspace 4";
            "alt-5" = "workspace 5";
            "alt-6" = "workspace 6";
            "alt-7" = "workspace 7";
            "alt-8" = "workspace 8";
            "alt-9" = "workspace 9";
            "alt-0" = "workspace 10";
            "alt-shift-1" = "move-node-to-workspace 1";
            "alt-shift-2" = "move-node-to-workspace 2";
            "alt-shift-3" = "move-node-to-workspace 3";
            "alt-shift-4" = "move-node-to-workspace 4";
            "alt-shift-5" = "move-node-to-workspace 5";
            "alt-shift-6" = "move-node-to-workspace 6";
            "alt-shift-7" = "move-node-to-workspace 7";
            "alt-shift-8" = "move-node-to-workspace 8";
            "alt-shift-9" = "move-node-to-workspace 9";
            "alt-tab" = "workspace-back-and-forth";
            "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
            "alt-shift-semicolon" = "mode service";
          };
          service.binding = {
            esc = [ "reload-config" "mode main" ];
            r = [ "flatten-workspace-tree" "mode main" ];
            f = [ "layout floating tiling" "mode main" ];
            backspace = [ "close-all-windows-but-current" "mode main" ];
            "alt-shift-left" = [ "join-with left" "mode main" ];
            "alt-shift-down" = [ "join-with down" "mode main" ];
            "alt-shift-up" = [ "join-with up" "mode main" ];
            "alt-shift-right" = [ "join-with right" "mode main" ];
          };
        };

        # Window detection rules
        on-window-detected = [
          {
            "if" = { app-id = "com.mitchellh.ghostty"; };
            run = [ "layout floating" ];
          }
        ];
      };
    };
  };
}
