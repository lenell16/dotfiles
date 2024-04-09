{ inputs, config, pkgs, lib, ... }:
{

  nixpkgs.overlays = [ inputs.neovim-overlay.overlay ];
  imports = [
    ./packages.nix
  ];

  home = {
    stateVersion = "24.05"; # Please read the comment before changing.

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    # file = {
    #   hammerspoon = lib.mkIf pkgs.stdenvNoCC.isDarwin {
    #     source = ./../config/hammerspoon;
    #     target = ".hammerspoon";
    #     recursive = true;
    #   };
    # };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      # PAGER = "bat";
      # LESS = "-R";
      # BAT_THEME = "OneHalfDark";
      # BAT_STYLE = "header,grid";
      # BAT_TABS = "2";
      # BAT_DIFF_CONTEXT = "3";
      # BAT_DIFF_NUMBERS = "true";
      # BAT_DIFF_FILE_SIZE_THRESHOLD = "1M
    };
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
        set fish_greeting # N/A
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';

      functions = {
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
        any-nix-shell fish --info-right | source
      '';
      # source /Users/alonzothomas/.local/share/nvim/site/pack/packer/start/nightfox.nvim/extra/nightfox/nightfox_fish.fish
      # ${pkgs.atuin}/bin/atuin init fish | source
    };

    kitty = {
      package = pkgs.kitty;
      enable = true;
      settings = {
        macos_option_as_alt = true;
        inactive_text_alpha = "0.5";
      };
      keybindings = {
        # /* "shift+enter" = "send_text all \x1b[13;2u"; */
      };
      extraConfig = ''
        include /Users/alonzothomas/.local/share/nvim/site/pack/packer/start/nightfox.nvim/extra/nightfox/nightfox_kitty.conf
      '';
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      # options = [ "--cmd cd" ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    #   starship = {
    #     enable = true;

    #     settings = {
    #       command_timeout = 100;
    #       format = "[$all](dimmed white)";

    #       character = {
    #         success_symbol = "[❯](dimmed green)";
    #         error_symbol = "[❯](dimmed red)";
    #       };

    #       git_status = {
    #         style = "bold yellow";
    #         format = "([$all_status$ahead_behind]($style) )";
    #       };

    #       jobs.disabled = true;
    #     };
    #   };

    #   jujutsu = {
    #     enable = true;
    #   };
    neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
    };
  };
}
