{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {

  imports = [
    ./dotfiles
    ./programs
  ];

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
  };

  home =
    let NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
    in
    {
      stateVersion = "22.05";
      sessionVariables = {
        DOTBARE_DIR = "$HOME/dotfiles";
        DOTBARE_TREE = "$HOME";
        NIXPKGS_ALLOW_INSECURE = 1;
        NIXPKGS_ALLOW_UNFREE = 1;
        TERMINFO_DIRS = "${pkgs.stable.kitty.terminfo.outPath}/share/terminfo";
        EDITOR = "nvim";
        VISUAL = "nvim";
        NODE_PATH = "${NODE_GLOBAL}/lib";
      };

      sessionPath = [
        "${NODE_GLOBAL}/bin"
      ];

      packages = with pkgs; [
        any-nix-shell
        amp
        black
        stable.blender
        cargo
        cloudflared
        cloud-sql-proxy
        cocoapods
        # crystal_1_2
        curl
        deno
        fd
        ffmpeg
        fx
        gitflow
        gitkraken
        google-cloud-sdk
        httpie
        kubectx
        # lucky-cli
        micro
        miller
        mongodb
        ngrok
        neovim-nightly
        nixpkgs-fmt
        nodejs-16_x
        nodePackages.eslint_d
        nodePackages.fixjson
        nodePackages.pnpm
        nodePackages.prettier
        nodePackages.typescript
        nodePackages.zx
        overmind
        pkg-config
        procs
        ripgrep
        rustc
        rustfmt
        sd
        selene
        shellcheck
        shfmt
        streamlink
        stylua
        tree
        unison-ucm
        vault
        wally-cli
        watchman
        wget
        viu
        xplr
        yarn
        yt-dlp
      ];
    };

  programs = {
    # atuin = {
    #   enable = true;
    # };

    bat.enable = true;

    bottom.enable = true;

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    fish = {
      enable = true;
      shellInit = ''
        any-nix-shell fish --info-right | source
      '';
      # interactiveShellInit = ''
      #   ${pkgs.atuin}/bin/atuin init fish | source
      # '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    git = {
      enable = true;
      userName = "lenell16";
      userEmail = "lenell16@gmail.com";
      includes = [
        {
          path = "${inputs.gitalias}/gitalias.txt";
        }
      ];
    };

    gitui = {
      enable = true;
    };

    go.enable = true;

    helix = {
      enable = true;
    };

    jq.enable = true;

    kakoune = {
      enable = true;
    };

    kitty = {
      package = pkgs.stable.kitty;
      enable = true;
      settings = {
        macos_option_as_alt = true;
      };
      extraConfig = ''
        include ${inputs.rose-pine-kitty}/dist/rose-pine-moon.conf
      '';
    };

    lazygit.enable = true;

    mpv.enable = true;

    nnn.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        cmd_duration.disabled = true;
        gcloud.disabled = true;
      };
    };

    tmux.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
