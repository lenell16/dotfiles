{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./packages.nix
    ./aliases.nix
    inputs.onepassword-shell-plugins.hmModules.default
  ];

  home = {
    stateVersion = "24.05"; # Please read the comment before changing.

    # Environment variables
    sessionVariables = {
      # Editor settings
      EDITOR = "nvim";
      VISUAL = "nvim";

      # Pager settings
      LESS = "-R";

      # Podman configuration
      DOCKER_HOST = "unix:///var/folders/zy/gd7_972101sdqv5_625lgdmh0000gn/T/podman/podman-machine-default-api.sock";

      # JIRA CLI configuration - set token via: op item get "Jira API Token" --fields password
      # JIRA_API_TOKEN = ""; # Set this via 1Password or environment

      # XDG data dirs (for shell integration)
      XDG_DATA_DIRS = "${config.home.profileDirectory}/share:${"\${GHOSTTY_SHELL_INTEGRATION_XDG_DIR:+\$GHOSTTY_SHELL_INTEGRATION_XDG_DIR:}"}$XDG_DATA_DIRS";

      # Make Nix-provided pkg-config files visible to builds (e.g., node-canvas)
      PKG_CONFIG_PATH = "${config.home.profileDirectory}/lib/pkgconfig:${config.home.profileDirectory}/share/pkgconfig";
    };

    sessionPath = lib.mkAfter [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
      "${config.home.homeDirectory}/.npm-global/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];

    # Files to create in home directory
    file = {
      # Suppress the login message on macOS terminal
      ".hushlogin".text = "";
    };
  };

  home.activation.refreshOpSession = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "${config.home.homeDirectory}/.config/op/auto-signin.fish" ]; then
      ${lib.getBin pkgs.fish}/bin/fish "${config.home.homeDirectory}/.config/op/auto-signin.fish"
    fi
  '';

  # Create symlink to 1Password SSH agent socket without spaces in path
  home.activation.create1PasswordSSHSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.ssh/1password"
    ln -sf "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
           "${config.home.homeDirectory}/.ssh/1password/agent.sock"
  '';

  home.activation.installMissingApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.bash}/bin/bash ${config.home.homeDirectory}/Developer/personal/dotfiles/scripts/install-missing-apps.sh
  '';

  home.activation.bunGlobals = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Install bun globals if they don't exist
    PATH="${pkgs.bun}/bin:$PATH"

    if ! bun pm ls -g | grep -q "@google/gemini-cli"; then
      echo "Installing missing bun global: @google/gemini-cli"
      $DRY_RUN_CMD bun install -g @google/gemini-cli@latest
    fi

    if ! bun pm ls -g | grep -q "opencode-ai"; then
      echo "Installing missing bun global: opencode-ai"
      $DRY_RUN_CMD bun install -g opencode-ai@latest
    fi

    if ! bun pm ls -g | grep -q "@dataramen/cli"; then
      echo "Installing missing bun global: @dataramen/cli"
      $DRY_RUN_CMD bun install -g @dataramen/cli@latest
    fi

    if ! bun pm ls -g | grep -q "protoc-gen-grpc"; then
      echo "Installing missing bun global: protoc-gen-grpc"
      $DRY_RUN_CMD bun install -g protoc-gen-grpc@latest
    fi

    if ! bun pm ls -g | grep -q "@sourcegraph/amp"; then
      echo "Installing missing bun global: @sourcegraph/amp"
      $DRY_RUN_CMD bun install -g @sourcegraph/amp@latest
    fi

    if ! bun pm ls -g | grep -q "@anthropic-ai/claude-code"; then
      echo "Installing missing bun global: @anthropic-ai/claude-code"
      $DRY_RUN_CMD bun install -g @anthropic-ai/claude-code@latest
    fi
  '';

  programs = {
    # # 1Password Shell Plugins
    # _1password-shell-plugins = {
    #   enable = true;
    #   plugins = with pkgs; [
    #     ngrok # You already have this configured manually
    #     # Add other CLI tools you want to use with 1Password shell plugins
    #     # gh     # GitHub CLI (already enabled above)
    #     # awscli2
    #     # docker
    #   ];
    # };

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

    bottom = {
      enable = true; # System monitor (like htop)
    };

    broot = {
      enable = true; # Directory navigator
      enableFishIntegration = true;
    };

    eza = {
      enable = true; # Modern replacement for ls
      enableFishIntegration = true;
    };

    jq = {
      enable = true; # JSON processor
    };

    fzf = {
      enable = true; # Fuzzy finder
      enableFishIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
    };

    # Shell enhancements
    starship = {
      enable = true; # Customizable prompt
      enableFishIntegration = true;
      settings = {
        cmd_duration.disabled = true;
        gcloud.disabled = true;
      };
    };

    # File managers
    nnn = {
      enable = true; # Terminal file manager
      bookmarks = {
        d = "~/Documents";
        D = "~/Downloads";
        p = "~/Developer/personal";
        w = "~/Developer/work";
      };
    };

    # Text editors
    helix = {
      enable = true; # Modern editor
      settings = {
        theme = "tokyonight_storm";
      };
    };

    # Terminal multiplexer
    tmux = {
      enable = true; # Terminal session manager
      clock24 = true;
      historyLimit = 10000;
      terminal = "screen-256color";
    };

    # Terminal emulator
    ghostty = {
      enable = false; # Disabled due to build issues - using Homebrew version instead
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

      # Enable difftastic as difftool (not default diff)
      difftastic = {
        enable = false;              # Don't replace git diff
        enableAsDifftool = true;     # Enable as git difftool
        background = "dark";
        color = "always";
        display = "inline";          # Try inline instead of side-by-side
      };

      # Git configuration
      extraConfig = {
        push = {
          autoSetupRemote = true; # Auto set upstream on push
        };
        init = {
          defaultBranch = "main"; # Default branch name
        };
        pull = {
          rebase = false; # Merge by default on pull
        };
        fetch = {
          prune = true; # Remove remote branches that no longer exist
        };
        difftool = {
          prompt = false; # Don't ask "Launch difftastic?"
        };
        alias = {
          # Difftastic aliases for quick access to syntax-aware diffs
          dlog = "-c diff.external=difft log --ext-diff";
          dshow = "-c diff.external=difft show --ext-diff";
          ddiff = "-c diff.external=difft diff";
        };
      };

      # Git conditional includes for different profiles
      ignores = [
        # Ignore any folder named "Scratch" (case-insensitive)
        "[Ss]cratch/"
        "[Ss]cratch"

        # macOS files
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "Icon\r\r" # Icon must end with two \r
        "._*" # Thumbnails

        # macOS volume files
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"

        # Network files
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"

        # Editor files
        "*~"
        "*.swp"
        "*.swo"

        # Cursor AI editor files
        ".cursor/rules/personal"
        ".cursor/research"
        ".cursor/plan"
        ".cursor/commands/task-*"

        # AI files
        ".ai"

        # Windows files
        "Thumbs.db"
        "ehthumbs.db"
        "Desktop.ini"
      ];
      includes = [
        { path = "${inputs.gitalias}/gitalias.txt"; }
        {
          condition = "gitdir:~/Developer/personal/**";
          contents = {
            user = {
              name = "lenell16";
              email = "lenell16@gmail.com";
            };

          };
        }
        {
          condition = "gitdir:~/Developer/tribble/**";
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
      enable = true; # Terminal UI for Git
    };

    # SSH configuration with 1Password integration
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        # Personal GitHub (automatically uses personal SSH key)
        "github-personal" = {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityAgent = "${config.home.homeDirectory}/.ssh/1password/agent.sock";
        };
        
        # Work GitHub (automatically uses work SSH key)
        "github-work" = {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityAgent = "${config.home.homeDirectory}/.ssh/1password/agent.sock";
        };
        
        # Default for all other hosts
        "*" = {
          compression = true;
          serverAliveInterval = 60;
          serverAliveCountMax = 10;
          identityAgent = "${config.home.homeDirectory}/.ssh/1password/agent.sock";
          extraOptions = {
            AddKeysToAgent = "yes";
            UseKeychain = "yes";
          };
        };
      };
    };

    lazygit = {
      enable = true; # Interactive Git terminal UI
    };

    # Fish shell configuration
    fish = {
      enable = true;

      # Commands to run when starting a login shell
      loginShellInit = ''
        # Initialize Homebrew once per login session
        if test -x /opt/homebrew/bin/brew
          eval "$(/opt/homebrew/bin/brew shellenv)"
        end
      '';

      # Commands to run when starting an interactive shell
      interactiveShellInit = ''
        # Multiple ways to ensure no greeting
        set -U fish_greeting
        set -g fish_greeting ""

        # Ensure nix-darwin's system profile binaries are available
        if not contains "/run/current-system/sw/bin" $PATH
          set -gx PATH "/run/current-system/sw/bin" $PATH
        end

        # Set 1Password SSH agent socket
        set -gx SSH_AUTH_SOCK "${config.home.homeDirectory}/.ssh/1password/agent.sock"

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

        # Refresh 1Password CLI session and cache it locally
        op-relogin = ''
          if not set -q OP_ACCOUNT
            echo "Set OP_ACCOUNT to your 1Password account shorthand (e.g., my.1password.com)" >&2
            return 1
          end

          set -l session (op signin $OP_ACCOUNT --raw 2>/dev/null)
          if test $status -ne 0
            echo "Failed to refresh 1Password session" >&2
            return 1
          end
          if test -z "$session"
            echo "Failed to refresh 1Password session" >&2
            return 1
          end

          set -gx OP_SESSION $session
          set -l cache_file "$HOME/.cache/op/session"
          mkdir -p (dirname $cache_file)
          echo -n $session > $cache_file
          chmod 600 $cache_file
          echo "1Password session refreshed."
        '';

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

        # Load API keys from 1Password with caching
        load_op_key = ''
          # Usage: load_op_key <env_var_name> <op_path> [--force]
          # Example: load_op_key ANTHROPIC_API_KEY "op://your-vault/Anthropic/api-key"
          # Add --force as third argument to force refresh from 1Password

          if test (count $argv) -lt 2
            echo "Usage: load_op_key <env_var_name> <op_path> [--force]"
            return 1
          end

          set -l env_var $argv[1]
          set -l op_path $argv[2]
          set -l force_refresh false

          if test (count $argv) -ge 3; and test "$argv[3]" = "--force"
            set force_refresh true
          end

          # Create cache directory if it doesn't exist
          set -l cache_dir "$HOME/.cache/op_keys"
          mkdir -p $cache_dir 2>/dev/null

          # Use a hash of the op_path as the cache filename for security
          set -l cache_file "$cache_dir/"(echo -n $op_path | shasum | cut -d ' ' -f 1)

          # Check if we need to refresh the key (if file doesn't exist, is older than 24 hours, or force refresh is requested)
          set -l refresh false

          if test "$force_refresh" = "true"
            set refresh true
          else if not test -f $cache_file
            set refresh true
          else
            # Check file age (24 hour expiration)
            set -l file_age (math (date +%s) - (stat -f %m $cache_file))
            if test $file_age -gt 86400
              set refresh true
            end
          end

          # Refresh from 1Password if needed
          if test "$refresh" = "true"
            # Try to read the key, sign in if needed
            set -l key (op read $op_path 2>/dev/null)
            
            if test $status -ne 0
              eval (op signin 2>/dev/null)
              set key (op read $op_path 2>/dev/null)
              
              if test $status -ne 0
                echo "Error: Failed to authenticate with 1Password for $env_var" >&2
                return 1
              end
            end
            
            # Save to cache if successful
            if test -n "$key"
              echo -n $key > $cache_file
              chmod 600 $cache_file 2>/dev/null
            else
              echo "Error: Failed to load $env_var from 1Password" >&2
              return 1
            end
          end

          # Read from cache and set environment variable
          if test -f $cache_file
            set -gx $env_var (cat $cache_file)
            return 0
          else
            echo "Error: Cache file for $env_var not found" >&2
            return 1
          end
        '';

        # Force refresh all API keys
        refresh_api_keys = ''
          load_api_keys --force
        '';

        # Load all API keys
        load_api_keys = ''
          # Define your API keys here
          # Pass '--force' as an argument to force refresh all keys
          set -l force_arg ""
          if test (count $argv) -gt 0; and test "$argv[1]" = "--force"
            set force_arg "--force"
          end

          # load_op_key ANTHROPIC_API_KEY "op://Personal/Anthropic API Key/api key" $force_arg
          # load_op_key OPENAI_API_KEY "op://Personal/sadrtemi4z73i4jcyi27owmi54/api key" $force_arg
          # Add more keys as needed
        '';

        # Auto-switch GitHub CLI account based on directory (manual function)
        gh-switch-account = ''
          set -l current_dir (pwd)
          if string match -q "*/Developer/personal/*" $current_dir
            gh auth switch --user lenell16 >/dev/null 2>&1
            echo "Switched to personal GitHub account (lenell16)"
          else if string match -q "*/Developer/tribble/*" $current_dir
            gh auth switch --user alonzotribble >/dev/null 2>&1
            echo "Switched to work GitHub account (alonzotribble)"
          else
            echo "Not in a recognized project directory"
          end
        '';
      };

      # Handy abbreviations for 1Password CLI tasks
      shellAbbrs = {
        ops = "op signin --raw";
        opc = "op account list";
      };

      # Aliases are now managed in aliases.nix

      # Commands to run when starting any shell
      shellInit = ''
        set -l starship_bin "${lib.getBin config.programs.starship.package}/bin"
        if not contains $starship_bin $PATH
          set -gx PATH $starship_bin $PATH
        end

        # Ghostty terminal integration
        if test -n "$GHOSTTY_SHELL_INTEGRATION_XDG_DIR"
            source $GHOSTTY_SHELL_INTEGRATION_XDG_DIR/fish/vendor_conf.d/ghostty-shell-integration.fish
        end

        # Nix shell integration
        any-nix-shell fish --info-right | source

        # Load all API keys from 1Password
        load_api_keys

        # 1Password CLI plugin integration
        set -l op_plugin "${config.home.homeDirectory}/.config/op/plugins.sh"
        if test -f $op_plugin
          source $op_plugin
        end
      '';
    };

    # Directory navigation enhancement
    zoxide = {
      enable = true; # Smart cd command
      enableFishIntegration = true;
      options = [ "--cmd j" ]; # Use 'j' as the command
    };

    # Text editor
    neovim = {
      enable = true; # Neovim editor
      package = pkgs.neovim-unwrapped;
      defaultEditor = true;
      viAlias = true; # Use 'vi' command for neovim
      vimAlias = true; # Use 'vim' command for neovim
    };

    # Window Manager
    aerospace = {
      enable = true;
      launchd.enable = true;
      userSettings = {
        # General settings
        start-at-login = false;
        after-login-command = [ ];
        after-startup-command = [
          "layout tiles horizontal vertical"
        ];

        # Normalizations
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        # Layouts
        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "horizontal";

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

        # Monitor assignments
        # Ensure workspace 1 is on the main monitor and workspace 2 is on the secondary monitor when present.
        # When only one monitor is connected, both workspaces remain available on the single monitor.
        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "secondary";
        };

        # Modes and Bindings
        mode = {
          main.binding = {
            "alt-slash" = "layout tiles horizontal vertical";
            "alt-comma" = "layout accordion horizontal vertical";
          
  
            "alt-shift-minus" = "resize smart -50";
            "alt-shift-equal" = "resize smart +50";
            "alt-1" = "workspace 1";
            "alt-2" = "workspace 2";
            "alt-shift-1" = "move-node-to-workspace 1";
            "alt-shift-2" = "move-node-to-workspace 2";
            "alt-tab" = "workspace-back-and-forth";
            "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
            "alt-shift-semicolon" = [
              "mode service"
              "exec-and-forget /opt/homebrew/opt/borders/bin/borders active_color=0xffff6600 inactive_color=0x00000000 width=5"
            ];
          };
          service.binding = {
            esc = [
              "exec-and-forget pkill -f borders"
              "reload-config"
              "mode main"
            ];
            r = [
              "exec-and-forget pkill -f borders"
              "flatten-workspace-tree"
              "mode main"
            ];
            "n" = "focus --ignore-floating left";
            "e" = "focus --ignore-floating down";
            "o" = "focus --ignore-floating up";
            "i" = "focus --ignore-floating right";
            "alt-n" = "move left";
            "alt-e" = "move down";
            "alt-o" = "move up";
            "alt-i" = "move right";
            "cmd-alt-n" = [
              "join-with left"
            ];
            "cmd-alt-e" = [
              "layout accordion vertical"
            ];
            "cmd-alt-o" = [
              "layout accordion vertical"
            ];
            "cmd-alt-i" = [
              "join-with right"
            ];
          };
        };
      };
    };
  };
}
