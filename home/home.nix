{ inputs, config, pkgs, lib, ... }:
{

  imports = [
    ./packages.nix
  ];

  home = {
    stateVersion = "24.05"; # Please read the comment before changing.

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";

      XDG_DATA_DIRS = "${config.home.profileDirectory}/share:${"\${GHOSTTY_SHELL_INTEGRATION_XDG_DIR:+\$GHOSTTY_SHELL_INTEGRATION_XDG_DIR:}"}$XDG_DATA_DIRS";

      # PAGER = "bat";
      # LESS = "-R";
      # BAT_THEME = "OneHalfDark";
      # BAT_STYLE = "header,grid";
      # BAT_TABS = "2";
      # BAT_DIFF_CONTEXT = "3";
      # BAT_DIFF_NUMBERS = "true";
      # BAT_DIFF_FILE_SIZE_THRESHOLD = "1M
    };

    file.".hushlogin".text = "";
  };

  programs = {
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

    bat.enable = true;

    bottom.enable = true;

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
    };

    jq.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        cmd_duration.disabled = true;
        gcloud.disabled = true;
      };
    };

    helix = {
      enable = true;
      settings = {
        theme = "tokyonight_storm";
      };
    };

    tmux.enable = true;

    mpv.enable = true;

    nnn.enable = true;

    git = {
      enable = true;
      # userName = "lenell16";
      # userEmail = "lenell16@gmail.com";
      includes = [
        {
          path = "${inputs.gitalias}/gitalias.txt";
        }
      ];
      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    gitui = {
      enable = true;
    };

    lazygit.enable = true;

    fish = {
      enable = true;

      interactiveShellInit = ''
        # Multiple ways to ensure no greeting
        set -U fish_greeting
        set -g fish_greeting ""
        
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';

      functions = {
        fish_greeting = ""; # This explicitly overrides the greeting function
        mcd = ''
          mkdir -p $argv
          cd $argv
        '';
      };
      shellAliases = with pkgs;
        {
          # Nix related
          # drs = "darwin-rebuild switch --flake ${config.home.user-info.nixConfigDirectory}";
          # flakeup = "nix flake update ${config.home.user-info.nixConfigDirectory}";
          # nb = "nix build";
          # nf = "nix flake";

          # Other
          ".." = "cd ..";
          ":q" = "exit";
          cat = "${bat}/bin/bat";

          g = "${gitAndTools.git}/bin/git";
        };
      shellInit = ''
        if test -n "$GHOSTTY_SHELL_INTEGRATION_XDG_DIR"
            source $GHOSTTY_SHELL_INTEGRATION_XDG_DIR/fish/vendor_conf.d/ghostty-shell-integration.fish
        end
        any-nix-shell fish --info-right | source
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      # options = [ "--cmd cd" ];
    };

    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      defaultEditor = true;
    };
  };
}
