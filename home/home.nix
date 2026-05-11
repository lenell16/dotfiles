{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  # Git picks the SSH key per repo via core.sshCommand (see hasconfig work includes + default settings).
  sshKeyLenell16 = "${config.home.homeDirectory}/.ssh/Github";
  sshKeyAlonzotribble = "${config.home.homeDirectory}/.ssh/tribble-github";
  gitSshLenell16 = "ssh -o IdentitiesOnly=yes -i ${sshKeyLenell16}";
  gitSshAlonzotribble = "ssh -o IdentitiesOnly=yes -i ${sshKeyAlonzotribble}";

  # Default Git identity is personal (lenell16). Work identity + work SSH key when any remote is
  # under the work GitHub user or org (same hasconfig patterns for user.email and core.sshCommand).
  gitWorkProfile = {
    user = {
      name = "Alonzo Thomas";
      email = "alonzo.thomas@tribble.ai";
    };
    core = {
      sshCommand = gitSshAlonzotribble;
    };
  };
  gitWorkRemoteIncludes =
    map
      (condition: {
        inherit condition;
        contents = gitWorkProfile;
      })
      [
        "hasconfig:remote.*.url:https://github.com/alonzotribble/**"
        "hasconfig:remote.*.url:git@github.com:alonzotribble/**"
        "hasconfig:remote.*.url:ssh://git@github.com/alonzotribble/**"
        "hasconfig:remote.*.url:https://github.com/tribble-ai/**"
        "hasconfig:remote.*.url:git@github.com:tribble-ai/**"
        "hasconfig:remote.*.url:ssh://git@github.com/tribble-ai/**"
      ];

  opEnvFishTpl = "${config.home.homeDirectory}/.config/op/env.fish.tpl";
  opEnvFish = "${config.home.homeDirectory}/.config/op/env.fish";
in
{

  imports = [
    ./packages.nix
    ./aliases.nix
    ./fish-path-dedupe.nix
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

      ".config/op/env.fish.tpl".text = ''
        set -gx AI_GATEWAY_API_KEY "{{ op://Personal/AI_GATEWAY_API_KEY/credential }}"
      '';
    };
  };

  # Resolve op:// placeholders into ~/.config/op/env.fish (no `op` on every shell — only hm switch).
  home.activation.injectOpEnvFish = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    HOME_DIR="${config.home.homeDirectory}"
    TPL="${opEnvFishTpl}"
    OUT="${opEnvFish}"
    OP_BIN=""
    for _op in /opt/homebrew/bin/op /usr/local/bin/op; do
      if [ -x "$_op" ]; then
        OP_BIN="$_op"
        break
      fi
    done

    if [ ! -f "$TPL" ]; then
      exit 0
    fi

    if [ -z "$OP_BIN" ]; then
      echo "home-manager: injectOpEnvFish: op not found; skipping $OUT" >&2
      exit 0
    fi

    if [ -n "$DRY_RUN_CMD" ]; then
      echo "home-manager: injectOpEnvFish: [dry-run] would op inject $TPL -> $OUT"
      exit 0
    fi

    tmp=$(mktemp "$HOME_DIR/.config/op/env.fish.tmp.XXXXXX")
    if ! "$OP_BIN" inject --in-file "$TPL" --out-file "$tmp" 2>/dev/null; then
      echo "home-manager: injectOpEnvFish: op inject failed; leaving any existing $OUT unchanged" >&2
      rm -f "$tmp"
      exit 0
    fi
    chmod 600 "$tmp"
    mv -f "$tmp" "$OUT"
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

    if ! bun pm ls -g | grep -q "@dataramen/cli"; then
      echo "Installing missing bun global: @dataramen/cli"
      $DRY_RUN_CMD bun install -g @dataramen/cli@latest
    fi

  '';

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

    # Git UI
    gitui = {
      enable = true;
    };

    # Syntax-aware diff (home-manager: was programs.git.difftastic)
    difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
      options = {
        background = "dark";
        color = "always";
        display = "inline";
      };
    };

    # Git configuration
    git = {
      enable = true;

      # Git settings (new API - replaces userName, userEmail, and extraConfig)
      settings = {
        user = {
          name = "lenell16";
          email = "lenell16@gmail.com";
        };
        core = {
          sshCommand = gitSshLenell16;
        };
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
      ]
      ++ gitWorkRemoteIncludes;
    };

    # Git UI tools
    # gitui = {
    #   enable = true; # Terminal UI for Git
    # };

    # SSH configuration with 1Password integration
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        # github.com: default key for ssh(1); Git uses core.sshCommand per repo. Legacy hostnames
        # keep a single key each so old remotes still work.
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityFile = [ sshKeyLenell16 ];
        };
        "github.com-personal" = {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityFile = [ sshKeyLenell16 ];
        };
        "github.com-work" = {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityFile = [ sshKeyAlonzotribble ];
        };

        # Airbyte prod VM tunnel
        "airbyte-prod" = {
          hostname = "4.236.179.205";
          user = "tribbleprod-airbyte-vm";
          identityFile = [ "~/Developer/tribble/tunnel-keys/vm-prod-airbyte_key.pem" ];
          localForwards = [
            {
              bind.port = 8100;
              host.address = "localhost";
              host.port = 8000;
            }
            {
              bind.port = 8101;
              host.address = "localhost";
              host.port = 8006;
            }
          ];
        };

        # Airbyte test VM tunnel
        "airbyte-test" = {
          hostname = "172.191.111.255";
          user = "tribbletest-airbyte-vm";
          identityFile = [ "~/Developer/tribble/tunnel-keys/vm-test-airbyte_key.pem" ];
          localForwards = [
            {
              bind.port = 8200;
              host.address = "localhost";
              host.port = 8000;
            }
            {
              bind.port = 8201;
              host.address = "localhost";
              host.port = 8006;
            }
          ];
        };

        # Airbyte staging VM tunnel
        "airbyte-staging" = {
          hostname = "20.42.57.107";
          user = "tribblestaging-airbyte-vm";
          identityFile = [ "~/Developer/tribble/tunnel-keys/vm-staging-airbyte_key.pem" ];
          localForwards = [
            {
              bind.port = 8300;
              host.address = "localhost";
              host.port = 8000;
            }
            {
              bind.port = 8301;
              host.address = "localhost";
              host.port = 8006;
            }
          ];
        };

        # Default for all other hosts
        "*" = {
          compression = true;
          serverAliveInterval = 60;
          serverAliveCountMax = 10;
          extraOptions = {
            AddKeysToAgent = "yes";
          };
        };
      };
    };

    lazygit = {
      enable = true; # Interactive Git terminal UI
    };

    # Terminal file manager (package from github:sxyazi/yazi flake via overlay)
    yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "y";
      package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
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

        # Regenerate ~/.config/op/env.fish from the template (runs `op inject`; use after vault changes)
        refresh_api_keys = ''
          set -l tpl "${opEnvFishTpl}"
          set -l out "${opEnvFish}"
          set -l op_bin
          for candidate in /opt/homebrew/bin/op /usr/local/bin/op
            if test -x $candidate
              set op_bin $candidate
              break
            end
          end
          if test -z "$op_bin"
            echo "refresh_api_keys: op not found (install 1password-cli)" >&2
            return 1
          end
          if not test -f $tpl
            echo "refresh_api_keys: missing $tpl" >&2
            return 1
          end
          set -l tmp (mktemp -t op_env_fish.XXXXXX)
          if not $op_bin inject --in-file $tpl --out-file $tmp 2>/dev/null
            rm -f $tmp
            echo "refresh_api_keys: op inject failed (unlock 1Password?)" >&2
            return 1
          end
          chmod 600 $tmp
          mv -f $tmp $out
          source $out
        '';

        # Load API keys produced by home-manager activation (injectOpEnvFish) or refresh_api_keys
        load_api_keys = ''
          if test -f "${opEnvFish}"
            source "${opEnvFish}"
          end
        '';

        # Re-detect GitHub CLI user from current repo (see shellInit __dotfiles_gh_autoswitch)
        gh-resync-account = ''
          set -e __dotfiles_gh_git_top
          __dotfiles_gh_autoswitch
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

        # API keys: source ~/.config/op/env.fish (refreshed by home-manager switch or refresh_api_keys)
        load_api_keys

        # GitHub CLI: default lenell16; work account if any remote is tribble-ai or alonzotribble
        function __dotfiles_gh_autoswitch_apply
          set -l top $argv[1]
          if test -z "$top"
            gh auth switch --user lenell16 >/dev/null 2>&1
            return
          end
          for remote in (git -C $top remote 2>/dev/null)
            set -l url (git -C $top remote get-url $remote 2>/dev/null)
            test -z "$url"
            and continue
            if string match -qr 'github\.com[:/](alonzotribble|tribble-ai)/' $url
              gh auth switch --user alonzotribble >/dev/null 2>&1
              return
            end
          end
          gh auth switch --user lenell16 >/dev/null 2>&1
        end

        function __dotfiles_gh_autoswitch
          set -l top (git rev-parse --show-toplevel 2>/dev/null)
          if test "$top" = "$__dotfiles_gh_git_top"
            return
          end
          set -g __dotfiles_gh_git_top $top
          __dotfiles_gh_autoswitch_apply $top
        end

        function __dotfiles_gh_on_pwd --on-variable PWD
          __dotfiles_gh_autoswitch
        end

        __dotfiles_gh_autoswitch
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
      # Explicit until home.stateVersion >= 26.05 (defaults changed in HM)
      withRuby = true;
      withPython3 = true;
    };

    # Window Manager
    aerospace = {
      enable = true;
      launchd.enable = true;
      settings = {
        # General settings
        start-at-login = false;
        after-login-command = [ ];
        after-startup-command = [
          "layout tiles horizontal vertical"
        ];

        # Ghostty tab workaround: treat tabs as a single window instead of separate windows
        on-window-detected = [
          {
            "if".app-id = "com.mitchellh.ghostty";
            run = [ "layout tiling" ];
          }
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
