{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {

  imports = [
    ./dotfiles
    ./programs
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
  };

  home =
    let NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
    in
    {
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
        cocoapods
        crystal_1_2
        curl
        deno
        fd
        ffmpeg
        fx
        gitflow
        gitkraken
        gh
        google-cloud-sdk
        httpie
        iina
        kubectx
        lucky-cli
        micro
        miller
        mongodb
        ngrok
        neovim-nightly
        nixpkgs-fmt
        nodejs_latest
        nodePackages.eslint_d
        nodePackages.fixjson
        nodePackages.pnpm
        nodePackages.prettier
        nodePackages.typescript
        openconnect
        overmind
        procs
        ripgrep
        sd
        selene
        shellcheck
        shfmt
        streamlink
        stylua
        tree
        vault
        wally-cli
        watchman
        wget
        viu
        xplr
        yarn
        youtube-dl
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
      shellAliases = {
        dotbare = "$HOME/.dotbare/dotbare";
      };
      # interactiveShellInit = ''
      #   ${pkgs.atuin}/bin/atuin init fish | source
      # '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      userName = "lenell16";
      userEmail = "lenell16@gmail.com";
      includes = [
        {
          path = ./dotfiles/git/gitalias/gitalias.txt;
        }
      ];
    };

    go.enable = true;

    # helix = {
    #   enable = true;
    # };

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
      extraConfig = builtins.readFile ./dotfiles/kitty/extraConfig.conf;
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
